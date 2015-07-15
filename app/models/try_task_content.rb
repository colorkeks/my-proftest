class TryTaskContent < ActiveRecord::Base
  belongs_to :task_result
  belongs_to :task_content_version, class_name: PaperTrail::Version

  validates :task_content_version_id, presence: true

  def task_content_was
    if !@task_content_was
      @task_content_was = self.task_content_version.item_version
      @task_content_was.instance_variable_set(:@new_record, false)
    end
    @task_content_was
  end
end
