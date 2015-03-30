class UserAnswer < ActiveRecord::Base
  belongs_to :task_result
  belongs_to :answer
  has_one :user_association
end
