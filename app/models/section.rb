class Section < ActiveRecord::Base
  belongs_to :test
  validates :test_id, presence: true

  def title
    self.name
  end
end
