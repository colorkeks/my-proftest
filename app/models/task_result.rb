class TaskResult < ActiveRecord::Base
  belongs_to :try
  belongs_to :task
  has_many :user_answers, dependent: :destroy
  has_many :user_associations, dependent: :destroy
  accepts_nested_attributes_for :user_answers
  accepts_nested_attributes_for :user_associations
end
