class Test < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :user
  has_many :tries
  has_many :tasks, dependent: :destroy
  has_many :assigned_tests
  acts_as_nested_set
  belongs_to :test_group
  has_many :sections, dependent: :destroy
  has_many :eqvgroups, dependent: :destroy
  has_many :chains, dependent: :destroy
  after_create :add_eqvgroup
  include SoftDeletion
  has_paper_trail

  def self.search_test(q,mode)
    if mode == 'Аттестация'
      if q.empty?
        Test.all
      else
        Test.where("description LIKE ? OR title LIKE ?", "#{q}%", "%#{q}%")
      end
    elsif mode == 'Тренировка'
      if q.empty?
        Test.all.where(attestation: false)
      else
        Test.where("description LIKE ? OR title LIKE ? AND attestation = false", "#{q}%", "%#{q}%")
      end
    end
  end

  def add_eqvgroup
    eg = self.eqvgroups.build(number: 1)
    eg.save!
  end

end
