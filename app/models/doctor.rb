class Doctor < ActiveRecord::Base
  self.table_name = 'doctor_dbfs'
  acts_as_copy_target
  has_one :lpu_dbfs, class_name: 'LpuDbf', :foreign_key => :lpucode, primary_key: 'lpuwork'
  has_many :officfun_dbfs, class_name: 'OfficfunDbf', :foreign_key => :drcode, primary_key: 'drcode'
  belongs_to :user, :foreign_key => :drcode, primary_key: 'drcode'

  def current_lpu
    self.lpu_dbfs
  end

  def self.search_doctor(q)
    q = q.strip.mb_chars.upcase.to_s
    if q.empty?
      self.none
    else
      qs = q.split(' ').map{|i| i+'%'}
      query = %w(name surname secname drcode).permutation(qs[0..3].length).map do|p|
        fields = p.each_with_index.map{|f,i| "#{f} LIKE(#{self.sanitize(qs[i])})"}.join(' AND ')
        "(#{fields})"
      end.join(' OR ')

      Doctor.where(query)
    end
  end
end