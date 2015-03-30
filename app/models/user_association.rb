class UserAssociation < ActiveRecord::Base
  belongs_to :task_result
  has_one :user_answer
end
