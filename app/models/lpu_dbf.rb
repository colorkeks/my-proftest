class LpuDbf < ActiveRecord::Base
  acts_as_copy_target
  belongs_to :doctor_dbf, class_name: 'Doctor', foreign_key: :lpuwork, primary_key: 'lpucode'
  belongs_to :officfun_dbf, class_name: 'OfficfunDbf', foreign_key: :lpuwork, primary_key: 'lpucode'

  default_scope {where('dateend is null')}

  def title
    self.name_s || self.name
  end
end