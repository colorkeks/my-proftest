class TestMode < ActiveRecord::Base
  has_many :tries
  has_many :assigned_tests
  belongs_to :user
end
