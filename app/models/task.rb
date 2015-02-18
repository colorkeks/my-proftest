class Task < ActiveRecord::Base
  has_many :answers
  belongs_to :test
end
