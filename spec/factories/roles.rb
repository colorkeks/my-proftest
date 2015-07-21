FactoryGirl.define do
  factory :admin, class: Role do
    name 'Администратор'
  end

  factory :registrator, class: Role do
    name 'Регистратор'
  end

  factory :methodolog, class: Role do
    name 'Методолог'
  end

  factory :tested, class: Role do
    name 'Тестируемый'
  end

end
