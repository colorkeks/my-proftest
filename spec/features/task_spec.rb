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

  scenario 'Create single choose task', js: true do
    visit new_task_path(:task => {:task_type => 'Единичный выбор', :test_id => @test.id, section_id: 1, eqvgroup_id: 1 })

    page.execute_script("tinyMCE.activeEditor.setContent('task text');")
    fill_in 'task_answers_attributes_0_text', with: 'answer 1'
    fill_in 'task_answers_attributes_1_text', with: 'answer 2'
    choose 'task_answers_attributes_0_correct_true'

    # переходим на предпросмотр
    click_on 'show-preview'
    expect(page).to have_text('task text')
    expect(page).to have_text('answer 1')
    expect(page).to have_text('answer 2')

    choose('answers_1')
    click_on 'Ответить'
    page.document.synchronize do
      if find(:css, '.modal-content')
        expect(page).to have_text('Ответ верный')
        within(:css, '.modal-footer') { click_on 'Закрыть' }
      else
        raise Capybara::ElementNotFound
      end
    end

    click_on 'Закрыть'

    # переходим на редактирование
    click_on 'add-answer-btn'
    expect(page).to have_css('#task_answers_attributes_3_text')
    all('.remove > a')[2].click
    expect(page).not_to have_css('#task_answers_attributes_3_text')

  end

  scenario 'Create multi choose task', js: true do
    visit new_task_path(:task => {:task_type => 'Множественный выбор', :test_id => @test.id, section_id: 1, eqvgroup_id: 1 })

    page.execute_script("tinyMCE.activeEditor.setContent('task text');")
    fill_in 'task_answers_attributes_0_text', with: 'answer 1'
    fill_in 'task_answers_attributes_1_text', with: 'answer 2'
    check 'task_answers_attributes_0_correct'

    # переходим на предпросмотр
    click_on 'show-preview'
    expect(page).to have_text('task text')
    expect(page).to have_text('answer 1')
    expect(page).to have_text('answer 2')

    check('answers_1')
    click_on 'Ответить'
    page.document.synchronize do
      if find(:css, '.modal-content')
        expect(page).to have_text('Ответ верный')
        within(:css, '.modal-footer') { click_on 'Закрыть' }
      else
        raise Capybara::ElementNotFound
      end
    end

    click_on 'Закрыть'

    # переходим на редактирование
    click_on 'add-answer-btn'
    expect(page).to have_css('#task_answers_attributes_3_text')
    all('.remove > a')[2].click
    expect(page).not_to have_css('#task_answers_attributes_3_text')
  end

  scenario 'Create open task', js: true do
    visit new_task_path(:task => {:task_type => 'Открытый вопрос', :test_id => @test.id, section_id: 1, eqvgroup_id: 1 })

    page.execute_script("tinyMCE.activeEditor.setContent('task text');")
    fill_in 'task_answers_attributes_0_text', with: 'answer 1'
    fill_in 'task_answers_attributes_1_text', with: 'answer 2'

    # переходим на предпросмотр
    click_on 'show-preview'
    expect(page).to have_text('task text')

    fill_in 'user_answer', with: 'answer 1'
    click_on 'Ответить'
    page.document.synchronize do
      if find(:css, '.modal-content')
        expect(page).to have_text('Ответ верный')
        within(:css, '.modal-footer') { click_on 'Закрыть' }
      else
        raise Capybara::ElementNotFound
      end
    end

    click_on 'Закрыть'

    # переходим на редактирование
    click_on 'add-answer-btn'
    expect(page).to have_css('#task_answers_attributes_3_text')
    all('.remove > a')[2].click
    expect(page).not_to have_css('#task_answers_attributes_3_text')
  end

  scenario 'Create sequence task', js: true do
    visit new_task_path(:task => {:task_type => 'Последовательность', :test_id => @test.id, section_id: 1, eqvgroup_id: 1 })

    page.execute_script("tinyMCE.activeEditor.setContent('task text');")
    fill_in 'task_answers_attributes_0_text', with: 'answer 1'
    fill_in 'task_answers_attributes_1_text', with: 'answer 2'

    # переходим на предпросмотр
    click_on 'show-preview'
    expect(page).to have_text('task text')
    expect(page).to have_text('answer 1')
    expect(page).to have_text('answer 2')

    # todo: нет проверки на drag and drop

    click_on 'Ответить'
    page.document.synchronize do
      if find(:css, '.modal-content')
        expect(page).to have_text('Ответ верный')
        within(:css, '.modal-footer') { click_on 'Закрыть' }
      else
        raise Capybara::ElementNotFound
      end
    end

    click_on 'Закрыть'

    # переходим на редактирование
    click_on 'add-answer-btn'
    expect(page).to have_css('#task_answers_attributes_3_text')
    all('.remove > a')[2].click
    expect(page).not_to have_css('#task_answers_attributes_3_text')
  end

  scenario 'Create connect task', js: true do
    visit new_task_path(:task => {:task_type => 'Сопоставление', :test_id => @test.id, section_id: 1, eqvgroup_id: 1 })

    page.execute_script("tinyMCE.activeEditor.setContent('task text');")
    fill_in 'task_answers_attributes_0_text', with: 'answer 11'
    fill_in 'task_answers_attributes_1_text', with: 'answer 12'
    fill_in 'task_associations_attributes_0_text', with: 'answer 21'
    fill_in 'task_associations_attributes_1_text', with: 'answer 22'

    # переходим на предпросмотр
    click_on 'show-preview'
    expect(page).to have_text('task text')
    expect(page).to have_text('answer 11')
    expect(page).to have_text('answer 12')
    select('answer 21', :from => 'answers_1')
    select('answer 22', :from => 'answers_2')


    # todo: нет проверки на drag and drop

    click_on 'Ответить'
    page.document.synchronize do
      if find(:css, '.modal-content')
        expect(page).to have_text('Ответ верный')
        within(:css, '.modal-footer') { click_on 'Закрыть' }
      else
        raise Capybara::ElementNotFound
      end
    end

    click_on 'Закрыть'

    # переходим на редактирование
    click_on 'add-answer-btn'
    expect(page).to have_css('#task_answers_attributes_3_text')
    all('#answer_table .remove > a')[2].click
    expect(page).not_to have_css('#task_answers_attributes_3_text')

    click_on 'add-association-btn'
    expect(page).to have_css('#task_associations_attributes_3_text')
    all('#associate_table .remove > a')[2].click
    expect(page).not_to have_css('#task_associations_attributes_3_text')
  end

end