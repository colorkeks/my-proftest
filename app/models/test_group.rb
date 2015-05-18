class TestGroup < ActiveRecord::Base
  acts_as_nested_set
  has_many :tests, dependent: :destroy
end
