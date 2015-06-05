require 'dbf'

module DBF
  class Table
    def to_csv(path = nil)
      out_io = path ? File.open(path, 'w') : $stdout
      csv = csv_class.new(out_io)
      csv << column_names
      each { |record| csv << record.to_a }
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

end

DbfLoader.new('/home/lavrovdv/work/proftest/DOCTORS.DBF').load_data(DoctorDbf)
DbfLoader.new('/home/lavrovdv/work/proftest/LPU.DBF').load_data(LpuDbf)
DbfLoader.new('/home/lavrovdv/work/proftest/OFFICFUN.DBF').load_data(OfficfunDbf)

# load "#{Rails.root}/lib/tasks/dbf_loader.rb" 8:52 -