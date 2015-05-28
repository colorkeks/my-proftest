class TestGroup < ActiveRecord::Base
  acts_as_nested_set
  has_many :tests, dependent: :destroy
  #acts_as_paranoid
  include SoftDeletion

  def after_soft_delete
    self.children.map(&:soft_delete!)
  end

  def after_restore
    self.children.map(&:restore!)
  end

  def self.trash
    self.where(parent_id: nil, name: 'Корзина').first!
  end

  def is_trash?
    self == self.class.trash
  end
end
