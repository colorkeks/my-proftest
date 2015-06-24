class AssignedTest < ActiveRecord::Base
  belongs_to :user
  belongs_to :test
  belongs_to :test_mode
end
