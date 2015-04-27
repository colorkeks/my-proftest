class Test < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :user
  has_many :tries
  has_many :tasks, dependent: :destroy


  def self.search(search_tests)
    if search_tests
      self.where("title LIKE ? OR description LIKE ? OR algorithm LIKE ?", "%#{search_tests}%", "%#{search_tests}%", "%#{search_tests}%")
    else
      self.all
    end
  end
end
