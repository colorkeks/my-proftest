class Try < ActiveRecord::Base
  belongs_to :user
  belongs_to :test
  belongs_to :test_mode
  serialize :task_results_queue, Array
  has_many :task_results, dependent: :destroy
  accepts_nested_attributes_for :task_results

  def populate_tasks
    tasks = self.test.get_tasks_for_current_algorithm
    tasks.each do |task|
      task_result = self.task_results.build(:point => task.point, :text => task.text, :hint => task.hint, :task_type => task.task_type, :status => 'ответ не дан', :task_id => task.id)
      task.answers.each do |answer|
        task_result.user_answers.build(:user_reply => false, :correct => answer.correct, :text => answer.text, :serial_number => answer.serial_number, :point => answer.point, :task_id => task.id, :answer_id => answer.id, :user_association_id => nil)
      end
      task.associations.each do |association|
        task_result.user_associations.build(:text => association.text, :serial_number => association.serial_number, :task_id => task.id, :association_id => association.id, :user_answer_id => nil)
      end
    end
    self
  end

  def set_task_results_queue
    self.task_results_queue = self.task_results.map{|tr| tr.id}
  end

  def prepare
    self.populate_tasks
    result = self.save
    self.set_task_results_queue
    result = result && self.save
  end

end
