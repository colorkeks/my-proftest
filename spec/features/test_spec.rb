require 'rails_helper'

RSpec.feature 'Test', type: :feature do

  before :each do
    @test_group = TestGroup.create!(name: 'Тесты')
    @test = Test.create!(title: 'test', test_group: @test_group)
    TestGroup.create!(name: 'Корзина')
    @user = create(:methodolog_user)

    visit '/'
    click_on 'Войти'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Войти'

  end

  scenario 'Create task', js: true do
    ['Единичный выбор', 'Множественный выбор', 'Открытый вопрос', 'Последовательность', 'Сопоставление'].each do |task_type|
      visit test_path @test
      click_on 'Создать'
      click_on 'Задание'
      click_on task_type
      expect(page).to have_text(task_type)
    end
  end


  scenario 'Create space', js: true do
    visit test_path @test
    click_on 'Создать'
    click_on 'Раздел'

    page.document.synchronize do
      fill_in 'Название', with: 'new_space'
      click_on 'Сохранить'
    end
    expect(page).to have_text('new_space')

  end

  scenario 'Create chain', js: true do
    visit test_path @test
    click_on 'Создать'
    click_on 'Цепочку'

    expect(page).to have_text('Цепочка создана')
    expect(page).to have_text('Цепочка C#1')
  end

  scenario 'Move task to another space', js: true do
    section = Section.create!(name: 'section_name', test: @test)
    task = Task.create(text: 'task_text', task_type: 'Единичный выбор', test: @test, eqvgroup: Eqvgroup.first)

    visit test_path @test
    click_on 'toggle-checkboxes'
    click_on 'move-btn'

    page.document.synchronize do
      selected_section = all(:css, '.section')[1]
      if selected_section
        selected_section.click
        click_on 'Переместить'
      else
        raise Capybara::ElementNotFound
      end
    end

    within(:css, '.table-responsive') do
      expect(page).to have_text('section_name')
    end
  end

  scenario 'Remove task', js: true do
    Task.create(text: 'task_text', task_type: 'Единичный выбор', test: @test, eqvgroup: Eqvgroup.first)

    visit test_path @test
    click_on 'toggle-checkboxes'
    click_on 'remove-btn'

    within(:css, '.table-responsive') do
      expect(page).not_to have_text('task_text')
    end
  end

  scenario 'Change ecv_group', js: true do
    task = Task.create(text: 'task_text', task_type: 'Единичный выбор', test: @test, eqvgroup: Eqvgroup.first)
    new_ecv_group = Eqvgroup.create!(test: @test, number: 2)

    visit test_path @test
    click_on 'toggle-checkboxes'
    click_on 'change-eqvgroup'
    all(:css, '.change-eqvgroup-li > a')[1].click

    within(:css, '.table-responsive .label-info') do
      expect(page).to have_text('2')
    end
  end

  scenario 'Add ecv_group', js: true do
    visit test_path @test
    click_on 'change-eqvgroup'
    click_on 'Добавить'
    click_on 'change-eqvgroup'

    within(:css, '.dropdown-menu') do
      expect(page).to have_text('2')
    end
  end

  scenario 'Add to chain', js: true do
    task = Task.create(text: 'task_text', task_type: 'Единичный выбор', test: @test, eqvgroup: Eqvgroup.first)
    visit test_path @test

    click_on 'toggle-checkboxes'
    click_on 'other-btn'
    click_on 'Объединить в цепочку'

    expect(page).to have_text('Элементы успешно объеденены в цепочку')
    expect(first(:css, '.chain-start')).to_not be_nil
  end

  scenario 'Move to chain', js: true do
    task = Task.create(text: 'task_text', task_type: 'Единичный выбор', test: @test, eqvgroup: Eqvgroup.first)
    chain = Chain.create!(test: @test, eqvgroup_id: 1)

    visit test_path @test
    click_on 'toggle-checkboxes'
    click_on 'other-btn'
    click_on 'Переместить в цепочку'

    page.document.synchronize do
      selected_chain = first(:css, '.children > li > span')
      if selected_chain
        selected_chain.click
        click_on 'Переместить'
      else
        raise Capybara::ElementNotFound
      end
    end

    expect(first(:css, '.chain-start')).to_not be_nil
  end

  scenario 'Remove from chain', js: true do
    chain = Chain.create!(test: @test, eqvgroup_id: 1)
    task = Task.create(text: 'task_text', task_type: 'Единичный выбор', test: @test, eqvgroup: Eqvgroup.first, chain: chain)

    visit test_path @test
    click_on 'toggle-checkboxes'
    click_on 'other-btn'
    click_on 'Убрать из цепочки'

    expect(first(:css, '.chain-start')).to be_nil
  end

  scenario 'Check left sidebar links', js: true do
    visit test_path @test
    click_on 'Задания'
    expect(current_path).to eq(test_path @test)

    visit test_path @test
    click_on 'Цепочки'
    expect(current_path).to eq(test_chains_path @test)

    visit test_path @test
    click_on 'Корзина'
    expect(current_path).to eq(trash_test_path @test)

    visit test_path @test
    click_on 'Алгоритм'
    expect(current_path).to eq(algorithm_test_path @test)

    visit test_path @test
    click_on 'Статистика'
    expect(current_path).to eq(statistic_test_path @test)

    visit test_path @test
    click_on 'Настройки'
    page.document.synchronize do
      if first(:css, '#edit_test_1')
        expect(page).to have_text('Настройки теста')
      else
        raise Capybara::ElementNotFound
      end
    end

  end

  scenario 'Filter by space', js: true do
    task = Task.create(text: 'task_text', task_type: 'Единичный выбор', test: @test, eqvgroup: Eqvgroup.first)
    section = Section.create!(name: 'section_name', test: @test)

    visit test_path @test
    click_on 'section_name'

    expect(page).not_to have_text('task_text')
  end

  scenario 'Remove to trash', js: true do
    task = Task.create(text: 'task_text', task_type: 'Единичный выбор', test: @test, eqvgroup: Eqvgroup.first)
    visit test_path @test

    click_on 'toggle-checkboxes'
    click_on 'remove-btn'
    click_on 'Корзина'

    expect(page).to have_text('task_text')

    click_on 'toggle-checkboxes'
    click_on 'move-btn'

    page.document.synchronize do
      folder_item = first(:css, '.modal-body .section')

      if folder_item
        folder_item.click
        click_on 'Переместить'
      else
        raise Capybara::ElementNotFound
      end
    end

    click_on 'Корзина'

    within(:css, '.table-responsive') do
      expect(page).not_to have_text('task_text')
    end
  end

end