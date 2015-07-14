FactoryGirl.define do
  factory :user do
    email 'tmp@tmp.ru'
    password '123456789'
    first_name 'иван'
    last_name 'иванов'
    second_name 'иваноич'
    roles {[create(:admin), create(:methodolog), create(:tested)]}
  end

  factory :methodolog_user, class: User, parent: :user do
    roles {[create(:methodolog)]}
  end


end
