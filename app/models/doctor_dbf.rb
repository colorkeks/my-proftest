class DoctorDbf < ActiveRecord::Base
  acts_as_copy_target

  def self.search_doctor(q)
    q = q.strip.mb_chars.upcase.to_s
    if q.empty?
      []
    else
      qs = q.split(' ').map{|i| i+'%'}
      query = %w(name surname secname drcode).permutation(qs[0..3].length).map do|p|
        fields = p.each_with_index.map{|f,i| "#{f} LIKE(#{self.sanitize(qs[i])})"}.join(' AND ')
        "(#{fields})"
      end.join(' OR ')

      DoctorDbf.where(query)
    end
  end
end