class Section < ActiveRecord::Base
  belongs_to :test
  validates :test_id, presence: true
  has_many :tasks

  def title
    self.name
  end
end
