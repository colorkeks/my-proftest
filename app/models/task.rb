class Task < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :associations, dependent: :destroy
  has_many :task_contents, dependent: :destroy
  belongs_to :test
  accepts_nested_attributes_for :answers,  :reject_if => proc { |a| a['text'].blank? } , :allow_destroy => true
  accepts_nested_attributes_for :associations,  :reject_if => proc { |a| a['text'].blank? } , :allow_destroy => true
  accepts_nested_attributes_for :task_contents,:reject_if => proc { |a| a['file_content'].blank? }, :allow_destroy => true
  belongs_to :section
  belongs_to :eqvgroup
  validates :test_id, presence: true
  validates :eqvgroup_id, presence: true, if: 'existing?'
  validate :eqvgroup_and_section_valid, if: 'existing?'
  validate :chain_eqvgroup_and_section_valid, if: 'existing? && chain'
  include SoftDeletion

  belongs_to :chain
  acts_as_list scope: :chain, column: :chain_position

  def eqvgroup_and_section_valid
    if !(self.section == self.eqvgroup.section)
      errors.add(:eqvgroup, "Невозможно назначить данную группу")
    end
  end

  def chain_eqvgroup_and_section_valid
    if self.chain && !(self.section == self.chain.section && self.eqvgroup == self.chain.eqvgroup)
      errors.add(:chain, "Невозможно переместить в цепочку")
    end
  end

  def remove_from_list
    if in_list?
      old_position = send(position_column).to_i
      update_column position_column, nil # Удаляем id
      send("#{position_column}=", old_position)
      decrement_positions_on_lower_items
      set_list_position(nil)
      update_column scope_name, nil # Удаляем из scope
    end
  end

  def decrement_positions_on_lower_items
    return unless in_list?
    position ||= send(position_column).to_i
    acts_as_list_class.unscoped do
      acts_as_list_class.where(scope_condition).where(
          "#{position_column} > #{position}"
      ).order("#{position_column} ASC").each do |element|
        element.update_column position_column, (element.send(position_column).to_i - 1)
      end
    end
  end

  def move_to_trash!
    task = self
    task.eqvgroup = nil
    task.eqvgroup_id = 0
    task.section = nil
    task.soft_delete!
    task.reload
    task.remove_from_list
  end
  
  def check_answer(answers_param)
    answers = answers_param.is_a?(Hash) ? Answer.find(answers_param.keys) : nil

    case self.task_type
      when 'Единичный выбор'
        if (a = Answer.where(id: answers_param).first) && a.correct
          {correct: 'correct', point: self.point}
        else
          {correct: 'incorrect', point: 0}
        end

      when 'Множественный выбор'
        coefficient_incorrect = self.point.to_f / self.answers.where(:correct => false).count
        coefficient_correct   = self.point.to_f / self.answers.where(:correct => true).count
        correct_answers = answers.to_a.select(&:correct)
        percent_points = (correct_answers.size * coefficient_correct) - ((answers.size - correct_answers.size) * coefficient_incorrect)

        if percent_points == self.point
          {correct: 'correct', point: self.point}
        elsif percent_points <= 0
          {correct: 'incorrect', point: 0}
        else
          {correct: 'partial_correct', point: percent_points}
        end

      when 'Сопоставление'
        coefficient = self.point.to_f /  self.answers.count
        correct = answers.to_a.select do |a|
          association = self.associations.where(id: answers_param[a.id.to_s].first.to_i).first
          association && a.serial_number == association.serial_number
        end
        points = correct.size.to_f * coefficient

        if points == self.point
          {correct: 'correct', point: self.point}
        elsif points  == 0
          {correct: 'incorrect', point: 0 }
        else
          {correct: 'partial_correct', point: points}
        end

      when 'Последовательность'
        if answers.to_a.all?{|a| a.serial_number == answers_param[a.id.to_s].first.to_i }
          {correct: 'correct', point: self.point }
        else
          {correct: 'incorrect', point: 0 }
        end

      when 'Открытый вопрос'
        if self.answers.any?{|a| a.text.mb_chars.downcase == answers_param.mb_chars.downcase}
          {correct: 'correct', point: self.point }
        else
          {correct: 'incorrect', point: 0 }
        end
      else
    end
  end
  
end