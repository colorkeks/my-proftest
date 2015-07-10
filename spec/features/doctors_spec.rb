require 'rails_helper'

RSpec.feature 'Doctors', type: :feature do

  before :each do
    create(:doctor_dbf)
  end

  scenario 'Find doctor' do
    visit '/doctors'
    fill_in 'qwery_string', :with => 'Иванов'
    click_button('Найти')
    expect(page).to have_text('А1234')
  end
end
