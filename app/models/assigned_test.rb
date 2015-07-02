class AssignedTest < ActiveRecord::Base
  has_many :tries
  belongs_to :user
  belongs_to :test
  belongs_to :test_mode
end
