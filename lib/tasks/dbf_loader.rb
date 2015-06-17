require 'dbf'

module DBF
  class Table
    def to_csv(path = nil)
      out_io = path ? File.open(path, 'w') : $stdout
      csv = csv_class.new(out_io)
      csv << column_names
      each { |record| csv << record.to_a }
      out_io.close if path
      true
    end
  end
end

class DbfLoader

  def initialize(file_path)
    # system("dbf -c #{file_path} > /tmp/tmp.csv")
    table = DBF::Table.new(file_path)
    table.to_csv '/tmp/tmp.csv'

    csv = File.open('/tmp/tmp.csv', 'r+')
    str = csv.readline
    str.downcase!
    csv.rewind
    csv.write(str)
    csv.close
  end

  def load_data(model)
    model.delete_all
    model.copy_from "/tmp/tmp.csv"
  end

  def self.load(path)
    DbfLoader.new("#{path}/DOCTORS.DBF").load_data(DoctorDbf)
    DbfLoader.new("#{path}/LPU.DBF").load_data(LpuDbf)
    DbfLoader.new("#{path}/OFFICFUN.DBF").load_data(OfficfunDbf)
    DbfLoader.new("#{path}/POST.DBF").load_data(PostDbf)
    DbfLoader.new("#{path}/SPECLIST.DBF").load_data(SpeclistDbf)
  end

end

# load "#{Rails.root}/lib/tasks/dbf_loader.rb"
# DbfLoader.load('/home/deploy/')