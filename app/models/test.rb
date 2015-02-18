class Test < ActiveRecord::Base
  belongs_to :user
  has_many :tries
  has_many :tasks
end
