class LpuDbf < ActiveRecord::Base
  acts_as_copy_target
  belongs_to :doctor_dbf, class_name: 'DoctorDbf', foreign_key: :lpuwork, primary_key: 'lpucode'
  belongs_to :officfun_dbf, class_name: 'OfficfunDbf', foreign_key: :lpuwork, primary_key: 'lpucode'
end