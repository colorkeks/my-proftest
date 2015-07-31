class FixOldTries < ActiveRecord::Migration
  def change
    TaskResult.all.each do |task_result|
      if task_result.task_version_id.blank?
        task_result.task_version = Task.find(task_result.task_id).versions.last
        task_result.save!
      end
    end
    UserAnswer.all.each do |user_answer|
      if user_answer.answer_version_id.blank?
        user_answer.answer_version = Answer.find(user_answer.answer_id).versions.last
        user_answer.save!
      end
    end
    UserAssociation.all.each do |user_association|
      if user_association.association_version_id.blank?
        user_association.association_version = Association.find(user_association.association_id).versions.last
        user_association.save!
      end
    end    
  end
end
