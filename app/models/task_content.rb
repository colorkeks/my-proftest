class TaskContent < ActiveRecord::Base
  belongs_to :task
  has_attached_file :file_content,
                    styles: lambda { |a| a.instance.check_file_type}
  validates_attachment_content_type :file_content, :content_type => [/\Aimage\/.*\Z/, /\Avideo\/.*\Z/, /\Aaudio\/.*\Z/, /\Aapplication\/.*\Z/]

  def check_file_type
    if is_image_type?
      {:small => "x200>", :medium => "x300>", :large => "x400>"}
    elsif is_video_type?
      {}
    else
      {}
    end
  end
  def is_image_type?
    file_content_content_type =~ %r(image)
  end

  def is_video_type?
    file_content_content_type =~ %r(video)
  end
end
