class Association < ActiveRecord::Base
  belongs_to :task
  has_paper_trail
end
