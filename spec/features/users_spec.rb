require 'rails_helper'

RSpec.feature 'Users', type: :feature do

  before :each do
    @user = create(:admin_user)
    visit '/'
    click_on 'Войти'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Войти'

    @test_user = create(:tested_user)
  end

  scenario 'Show tested user', js: true do
    visit profile_user_path(@test_user)
    expect(page).to have_text('иванов иван иванович')
  end

  scenario 'Sign in by token', js: true do
    visit profile_user_path(@test_user)
    click_on 'Сгенерировать токен'

    first(:css, '.btn-group').click
    click_on 'Выйти'
    click_on 'Войти'

    fill_in 'token', with: @test_user.reload.token
    click_on 'Войти по токену'
    expect(page).to have_text 'Личный кабинет'

  end

end
