class TaskResult < ActiveRecord::Base
  belongs_to :try
  belongs_to :task
  has_many :user_answers, dependent: :destroy
  accepts_nested_attributes_for :user_answers
end
