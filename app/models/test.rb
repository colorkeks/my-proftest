class Test < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :user
  has_many :tries
  has_many :tasks, dependent: :destroy
  acts_as_nested_set
  belongs_to :test_group
  has_many :sections, dependent: :destroy
  has_many :eqvgroups, dependent: :destroy
  has_many :chains, dependent: :destroy
  after_create :add_eqvgroup
  include SoftDeletion

  def self.search_test(q)
    if q.empty?
      self.none
    else
      Test.where("description LIKE ? OR title LIKE ?", "#{q}%", "%#{q}%")
    end
  end

  def add_eqvgroup
    eg = self.eqvgroups.build(number: 1)
    eg.save!
  end

end
