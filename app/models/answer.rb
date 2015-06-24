class Answer < ActiveRecord::Base
  belongs_to :task, touch: true
  has_paper_trail
end
