class TestMode < ActiveRecord::Base
  has_many :tries
  belongs_to :user
end
