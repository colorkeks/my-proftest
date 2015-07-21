class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? :Администратор
      can :manage, :all
    elsif user.role? :Регистратор
      can :manage, :all
      cannot :destroy, :all
      cannot :assign_role, User
      cannot [:index,:show, :edit,:update], Test
      cannot [:index,:show, :edit,:update], Task
      cannot [:index,:show, :edit,:update], Answer
      cannot [:index,:show, :edit,:update], Association
      cannot [:index,:show, :edit,:update], TaskContent
      cannot [:index, :show, :edit], User
      can [:index, :show, :edit], User do |current_user|
        user.id == current_user.id
      end
    elsif user.role? :Методолог
      can :manage, :all
      # cannot :destroy, :all
      cannot :assign_role, User
      cannot [:index, :show, :edit, :update], User
      can [:index, :show, :edit, :update], User do |current_user|
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
      can [:show, :edit, :update, :testee_tab], User do |current_user|
        user.id == current_user.id
      end
    elsif user.new_record?
      can [:token_auth, :check_token], User
    end
  end
end
