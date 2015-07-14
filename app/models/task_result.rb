class TaskResult < ActiveRecord::Base
  belongs_to :try
  belongs_to :task
  has_many :user_answers, dependent: :destroy
  has_many :user_associations, dependent: :destroy
  accepts_nested_attributes_for :user_answers
  accepts_nested_attributes_for :user_associations
  belongs_to :task_version, class_name: PaperTrail::Version
  validates :task_version_id, presence: true
  has_many :try_task_contents, dependent: :destroy
  accepts_nested_attributes_for :try_task_contents
  
  def check_user_answer!(params)
    task_was = self.task_version.item_version
    earned_points = 0

    case task_was.task_type
      when 'Единичный выбор'
        selected_user_answer = self.user_answers.where(id: params[:user_answers]).first
        selected_user_answer.user_reply = true if selected_user_answer
        if selected_user_answer && selected_user_answer.answer_version.item_version.correct
          earned_points = task_was.point.to_f
        else
          earned_points = 0
        end

      when 'Множественный выбор'
        selected_user_answers = self.user_answers.where(id: params[:user_answers])
        answers_was = self.user_answers.map{|ua| ua.answer_version.item_version}
        coefficient_incorrect = task_was.point.to_f / answers_was.find_all{|a| !a.correct}.count
        coefficient_correct   = task_was.point.to_f / answers_was.find_all{|a| a.correct}.count
        correct_selected_user_answers = selected_user_answers.find_all{|ua| ua.answer_version.item_version.correct}
        incorrect_selected_user_answers = selected_user_answers.find_all{|ua| !ua.answer_version.item_version.correct}
        earned_points = (correct_selected_user_answers.size * coefficient_correct) - (incorrect_selected_user_answers.size * coefficient_incorrect)
        selected_user_answers.map{|ua| ua.user_reply = true}

      when 'Сопоставление'
        coefficient = task_was.point.to_f / self.user_answers.count
        correct_count = 0
        self.user_answers.each do |user_answer|
          arr = params[:associations][user_answer.id.to_s]
          selected_association_id = arr.first
          selected_association = self.user_associations.where(id: selected_association_id.to_i).first
          if selected_association
            user_answer.user_association = selected_association
          end
          current_serial_number = user_answer.answer_version.item_version.serial_number
          correct_association = self.user_associations.find{|ua| ua.association_version.item_version.serial_number == current_serial_number}

          if (selected_association.nil? && correct_association.nil?) || (selected_association && (current_serial_number == selected_association.association_version.item_version.serial_number))
            user_answer.correct = true
            correct_count += 1
          else
            user_answer.correct = false
          end
        end
        earned_points = correct_count * coefficient.to_f

      when 'Последовательность'
        incorrect_count = 0
        self.user_answers.each do |user_answer|
          selected_serial_number = params[:user_answers][user_answer.id.to_s].first.to_i
          user_answer.serial_number = selected_serial_number
          if selected_serial_number == user_answer.answer_version.item_version.serial_number
            user_answer.correct = true
          else
            user_answer.correct = false
            incorrect_count += 1
          end
        end

        if incorrect_count > 0
          earned_points = 0
        else
          earned_points = task_was.point.to_f
        end

      when 'Открытый вопрос'
        correct = false
        self.user_answers.each do |user_answer|
          if user_answer.answer_version.item_version.text.mb_chars.downcase == params[:user_answer]
            user_answer.user_reply = params[:user_answer]
            correct = true
          end
        end

        if correct
          earned_points = task_was.point.to_f
        else
          earned_points = 0
        end
      else
    end

    #Устанавливаем баллы
    if earned_points >= task_was.point
      self.status = 'правильно'
      self.point = task_was.point
    elsif earned_points <= 0
      self.status = 'не правильно'
      self.point = 0
    else
      self.status = 'частично правильно'
      self.point = earned_points
    end


  end

end



