class UserAnswer < ActiveRecord::Base
  belongs_to :task_result
  belongs_to :answer
  has_one :user_association

  belongs_to :answer_version, class_name: PaperTrail::Version
  validates :answer_version_id, presence: true

  def answer_was
    @answer_was ||= self.answer_version.item_version
  end

  def correct_user_association
    self.task_result.user_associations.find{|ua| ua.association_was.serial_number == self.answer_was.serial_number}
  end
end
