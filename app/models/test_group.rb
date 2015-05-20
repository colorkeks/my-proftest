class TestGroup < ActiveRecord::Base
  acts_as_nested_set
  has_many :tests, dependent: :destroy
  #acts_as_paranoid
end
