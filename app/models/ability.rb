class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :Супер_Юзер
      can :manage, :all
    elsif user.role? :Администратор
      can :manage, :all
      cannot :destroy, :all
      cannot :assign_role, User
      cannot [:index,:show, :edit,:update], Test
      cannot [:index,:show, :edit,:update], Task
      cannot [:index,:show, :edit,:update], Answer
      cannot [:index,:show, :edit,:update], Association
      cannot [:index,:show, :edit,:update], TaskContent
      cannot [:index, :show], User
      can [:show], User do |current_user|
        user.id == current_user.id
      end
    elsif user.role? :Методолог
      can :manage, :all
      # cannot :destroy, :all
      cannot :assign_role, User
      cannot [:custom_create,:index, :show, :edit, :update], User
      can [:show, :edit, :update], User do |current_user|
        user.id == current_user.id
      end
    elsif user.role? :Тестируемый
      can :manage, :all
      #cannot :destroy, :all
      cannot :assign_role, User
      #cannot :manage, Chapter
      cannot [:index,:show, :edit,:update], Test
      cannot [:index,:show, :edit,:update], Task
      cannot [:index,:show, :edit,:update], Answer
      cannot [:index,:show, :edit,:update], Association
      cannot [:index,:show, :edit,:update], TaskContent
      cannot [:index,:show, :edit,:update], TestGroup
      cannot [:index,:show, :edit,:update], Section
      cannot [:index,:show, :edit,:update], Eqvgroup
      cannot [:index,:show, :edit,:update], Chain
      cannot [:custom_create,:index, :show, :edit, :update], User
      can [:show, :edit, :update], User do |current_user|
        user.id == current_user.id
      end
  #  elsif user.has_role? :guest
  #    can :new, :create, User
    end
  end
end
