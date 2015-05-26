class Eqvgroup < ActiveRecord::Base
  belongs_to :test
  belongs_to :section
  has_many :tasks

  validates :test_id, presence: true
end
