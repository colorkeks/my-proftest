class UserAssociation < ActiveRecord::Base
  belongs_to :task_result
  has_one :user_answer

  belongs_to :association_version, class_name: PaperTrail::Version
  validates :association_version_id, presence: true
end
