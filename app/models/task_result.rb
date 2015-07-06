class TaskResult < ActiveRecord::Base
  belongs_to :try
  belongs_to :task
  has_many :user_answers, dependent: :destroy
  has_many :user_associations, dependent: :destroy
  accepts_nested_attributes_for :user_answers
  accepts_nested_attributes_for :user_associations
  belongs_to :task_version, class_name: PaperTrail::Version
  validates :task_version_id, presence: true
  has_many :try_task_contents, dependent: :destroy
  accepts_nested_attributes_for :try_task_contents
end
