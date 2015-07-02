class Try < ActiveRecord::Base
  belongs_to :user
  belongs_to :test
  belongs_to :test_mode
  belongs_to :assigned_test
  serialize :task_results_queue, Array
  has_many :task_results, dependent: :destroy
  accepts_nested_attributes_for :task_results

end
