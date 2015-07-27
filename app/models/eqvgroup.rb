class Eqvgroup < ActiveRecord::Base
  belongs_to :test
  belongs_to :section
  has_many :tasks
  has_many :chains, -> { uniq }, through: :tasks

  validates :test_id, presence: true
end
