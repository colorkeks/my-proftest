class Answer < ActiveRecord::Base
  belongs_to :task, touch: true
  has_many :user_answers
  has_paper_trail
end
