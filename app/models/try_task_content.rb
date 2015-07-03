class TryTaskContent < ActiveRecord::Base
  belongs_to :task_result
  belongs_to :task_content_version, class_name: PaperTrail::Version

  validates :task_content_version_id, presence: true
end
