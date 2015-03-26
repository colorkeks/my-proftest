class UserAnswer < ActiveRecord::Base
  belongs_to :task_result
  belongs_to :answer
end
