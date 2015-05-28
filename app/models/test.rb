class Test < ActiveRecord::Base
  include TheSortableTree::Scopes
  validates :title, presence: true
  belongs_to :user
  has_many :tries
  has_many :tasks, dependent: :destroy
  acts_as_nested_set
  belongs_to :test_group
  has_many :sections, dependent: :destroy
  has_many :eqvgroups, dependent: :destroy
  after_create :add_eqvgroup
  include SoftDeletion

  def self.search(search_tests)
    if search_tests
      self.where("title LIKE ? OR description LIKE ? OR algorithm LIKE ?", "%#{search_tests}%", "%#{search_tests}%", "%#{search_tests}%")
    else
      self.all
    end
  end

  def add_eqvgroup
    eg = self.eqvgroups.build(number: 1)
    eg.save!
  end

end
