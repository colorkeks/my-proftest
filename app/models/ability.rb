class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :Супер_Юзер
      can :manage, :all
    elsif user.role? :Администратор
      can :manage, :all
      cannot :manage
      cannot :destroy, :all
      cannot :edit, Role
    elsif user.role? :Методолог
      can :manage, :all
      cannot :edit, :destroy, Role
    elsif user.role? :Тестируемый
      can :manage, Try
      can :manage, User
      can :manage, UserAnswer
      can :manage, UserAssociation
      can :manage, TaskResult
      can :manage, Test
      can :manage, Task
      can :manage, Answer
      can :manage, Association
      can :manage, TaskContent
      can :destroy, :all
  #  elsif user.has_role? :guest
  #    can :new, :create, User
    end
  end
end
