class Section < ActiveRecord::Base
  belongs_to :test
  validates :test_id, presence: true
  has_many :tasks
  has_many :eqvgroups
  after_create :add_eqvgroup

  def title
    self.name
  end

  def add_eqvgroup
    if self.test.eqvgroups.any?
      last_number = self.test.eqvgroups.order(:number).last.number
    else
      last_number = 0
    end
    last_number += 1
    eg = self.test.eqvgroups.build(number: last_number)
    eg.section = self
    eg.save!
  end
end
