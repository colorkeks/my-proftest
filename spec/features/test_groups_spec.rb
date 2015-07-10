require 'rails_helper'

RSpec.feature 'TestGroups', type: :feature do
  # include Devise::TestHelpers

  before :each do
    @tg = TestGroup.create!(name: 'Тесты')
    TestGroup.create!(name: 'Корзина')
    @user = create(:user)
    visit '/'
    click_on 'Войти'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Войти'
  end

  def setup

  end

  scenario 'Create folder' do

    visit "/test_groups/#{@tg.id}"
    # p page.body
    # save_and_open_page
    # p current_url
    # save_and_open_screenshot

    click_on 'Создать'
    click_on 'Папку'
    fill_in 'Название', with: 'test_folder'
    click_button('Сохранить')
    expect(page).to have_text('test_folder')

  end
end
