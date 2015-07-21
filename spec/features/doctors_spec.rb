require 'rails_helper'

RSpec.feature 'Doctors', type: :feature do

  before :each do
    @user = create(:admin_user)
    visit '/'
    click_on 'Войти'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Войти'

    @doctor = create(:doctor)
  end

  scenario 'Find doctor', js: true do
    visit doctors_path
    fill_in 'qwery_string', :with => 'Иванов'
    click_button('Найти')
    expect(page).to have_text('А1234')
  end

  scenario 'Show doctor', js: true do
    visit doctor_path(id: @doctor.drcode)
    expect(page).to have_text('Иванов Иван Иванович')
  end
end
