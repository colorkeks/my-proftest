require 'rails_helper'

RSpec.describe Doctor, type: :model do

  before :each do
    @doctor = create(:doctor_dbf)
    @lpu = create(:lpu_dbf)
  end

  it 'search doctors' do
    expect(Doctor.search_doctor('Иванов иван иванович А1234').to_a).to eq([@doctor])
  end

  it 'don`t find doctors' do
    expect(Doctor.search_doctor('Петров').to_a).to eq([])
  end

  it 'return current lpu' do
    expect(@doctor.current_lpu).to eq(@lpu)
  end
end
