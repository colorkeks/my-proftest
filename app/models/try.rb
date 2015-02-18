class Try < ActiveRecord::Base
  belongs_to :user
  belongs_to :test
  has_many :task_results, dependent: :destroy
  accepts_nested_attributes_for :task_results
end
