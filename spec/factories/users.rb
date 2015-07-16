FactoryGirl.define do
  factory :user do
    email 'tmp@tmp.ru'
    password '123456789'
    first_name 'иван'
    last_name 'иванов'
    second_name 'иванович'
    birthday Date.today
    roles {[create(:admin), create(:methodolog), create(:tested)]}
  end

  factory :methodolog_user, class: User, parent: :user do
    roles {[create(:methodolog)]}
  end

  factory :admin_user, class: User, parent: :user do
    roles {[create(:admin)]}
  end

  factory :tested_user, class: User, parent: :user do
    email 'test@tmp.ru'
    roles {[create(:tested)]}
  end


end
