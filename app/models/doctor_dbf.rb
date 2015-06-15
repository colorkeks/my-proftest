class DoctorDbf < ActiveRecord::Base
  acts_as_copy_target
  has_many :lpu_dbfs, class_name: 'LpuDbf', :foreign_key => :lpucode, primary_key: 'lpuwork'
  has_many :officfun_dbfs, class_name: 'OfficfunDbf', :foreign_key => :drcode, primary_key: 'drcode'
end