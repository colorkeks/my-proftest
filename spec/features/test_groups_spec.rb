require 'rails_helper'

RSpec.feature 'TestGroups', type: :feature do
  # include Devise::TestHelpers

  before :each do
    @tg = TestGroup.create!(name: 'Тесты')
    TestGroup.create!(name: 'Корзина')
    @user = create(:methodolog_user)

    visit '/'
    click_on 'Войти'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Войти'
  end

  scenario 'Create folder', js: true do
    visit "/test_groups/#{@tg.id}"
    # p page.body
    # p current_url
    # save_and_open_page
    # save_and_open_screenshot

    click_on 'Создать'
    click_on 'Папку'
    fill_in 'Название', with: 'test_folder'
    click_button('Сохранить')
    expect(page).to have_text('test_folder')

  end

  scenario 'Create test', js: true do
    visit "/test_groups/#{@tg.id}"
    click_on 'Создать'
    click_on 'Тест'

    fill_in 'Название', with: 'new_test'
    click_button('Сохранить')
    expect(page).to have_text('new_test')
  end

  scenario 'Remove test and folder', js: true do
    TestGroup.create!(name: 'test_group', parent_id: @tg.id)
    Test.create!(title: 'test', test_group_id: @tg.id)

    visit "/test_groups/#{@tg.id}"
    click_on 'toggle-checkboxes'

    page.accept_confirm do
      click_on 'remove-btn'
    end

    expect(page).not_to have_text('test_group')
    expect(page).not_to have_text('test')
  end

  scenario 'Move test and folder', js: true do
    tg1 = TestGroup.create!(name: 'test_group', parent_id: @tg.id)
    tg2 = TestGroup.create!(name: 'test_group1', parent_id: @tg.id)
    test = Test.create!(title: 'test', test_group_id: @tg.id)

    visit "/test_groups/#{@tg.id}"
    first(:css, 'label[for="cb_1"]').click
    first(:css, 'label[for="cb_2"]').click
    click_on 'move-btn'

    page.document.synchronize do
      folder_item = all(:css, '.modal-body .folder-item')[1]
      if folder_item
        folder_item.click
        click_on 'Переместить'
      else
        raise Capybara::ElementNotFound
      end
    end

    expect(page).to have_text('Элементы успешно перемещены.')
    expect(tg1.children.first).to eq(tg2)
    expect(tg1.tests.first).to eq(test)

  end

  scenario 'Rename test', js: true do
    test = Test.create!(title: 'test', test_group_id: @tg.id)
    visit "/test_groups/#{@tg.id}"

    click_on 'toggle-checkboxes'
    click_on 'other-btn'
    first(:css, '#rename > a').click

    page.document.synchronize do
      fill_in 'Название', with: 'new_test_name'
      click_on 'Сохранить'
    end

    expect(page).to have_text('Элемент успешно обновлен')
    test.reload
    expect(test.title).to eq('new_test_name')
  end

  scenario 'Rename folder', js: true do
    test_group = TestGroup.create!(name: 'test_group', parent_id: @tg.id)
    visit "/test_groups/#{@tg.id}"

    click_on 'toggle-checkboxes'
    click_on 'other-btn'
    first(:css, '#rename > a').click

    page.document.synchronize do
      fill_in 'Название', with: 'new_test_group'
      click_on 'Сохранить'
    end

    expect(page).to have_text('Элемент успешно обновлен')
    test_group.reload
    expect(test_group.name).to eq('new_test_group')
  end
end
