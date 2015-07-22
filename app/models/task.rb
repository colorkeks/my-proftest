class Task < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :associations, dependent: :destroy
  has_many :task_contents, dependent: :nullify #:destroy
  has_many :task_results
  has_many :user_answers
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
  has_paper_trail
  before_save :nullify_task_contents

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

  def shuffle_positions_on_intermediate_items(old_position, new_position, avoid_id = nil)
    return if old_position == new_position
    avoid_id_condition = avoid_id ? " AND #{self.class.primary_key} != #{self.class.connection.quote(avoid_id)}" : ''

    update_column position_column, nil

    if old_position < new_position
      # Decrement position of intermediate items
      #
      # e.g., if moving an item from 2 to 5,
      # move [3, 4, 5] to [2, 3, 4]
      acts_as_list_class.unscoped do
        acts_as_list_class.where(scope_condition).where(
            "#{position_column} > #{old_position}"
        ).where(
            "#{position_column} <= #{new_position}#{avoid_id_condition}"
        ).order("#{position_column} ASC").each do |element|
          element.update_column position_column, (element.send(position_column).to_i - 1)
        end
      end
    else
      # Increment position of intermediate items
      #
      # e.g., if moving an item from 5 to 2,
      # move [2, 3, 4] to [3, 4, 5]
      acts_as_list_class.unscoped do
        acts_as_list_class.where(scope_condition).where(
            "#{position_column} >= #{new_position}"
        ).where(
            "#{position_column} < #{old_position}#{avoid_id_condition}"
        ).order("#{position_column} DESC").each do |element|
          element.update_column position_column, (element.send(position_column).to_i + 1)
        end
      end
    end
  end

  def add_to_list_bottom_with_check_scope_presence
    add_to_list_bottom_without_check_scope_presence if self.chain
  end

  alias_method_chain :add_to_list_bottom, :check_scope_presence

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
        coefficient = self.point.to_f / self.associations.count
        correct = answers.to_a.select do |a|
          association = self.associations.where(id: answers_param[a.id.to_s].to_i).first
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

  def nullify_task_contents
    self.task_contents.each do |task_content|
      if task_content.marked_for_destruction?
        task_content.instance_variable_set(:@marked_for_destruction, false)
        task_content.task_id = nil
      end
    end
  end

end