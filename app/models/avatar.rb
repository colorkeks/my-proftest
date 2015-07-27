class Avatar < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file_content, :styles => { :medium => "230x230", :thumb => "200x200>", :mini => "25x25" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :file_content, :content_type => /\Aimage\/.*\Z/
end