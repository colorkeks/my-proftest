class OfficfunDbf < ActiveRecord::Base
  acts_as_copy_target
  has_many :lpu_dbfs, class_name: 'LpuDbf', foreign_key: :lpucode, primary_key: 'lpuwork'
  has_many :speclist_dbfs, class_name: 'SpeclistDbf', foreign_key: :speccode, primary_key: 'speccode'
  has_many :post_dbfs, class_name: 'PostDbf', foreign_key: :postcode, primary_key: 'postcode'
  belongs_to :doctor_dbf, class_name: 'DoctorDbf', foreign_key: :drcode, primary_key: 'drcode'
end