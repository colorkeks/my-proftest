class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can [:show, :edit, :update], User do |current_user|
      user.id == current_user.id
    end
    if user.role? :Супер_Администратор
      can :manage, :all
    elsif user.role? :Администратор
      can :manage, Doctor
      can [:profile], User
    elsif user.role? :Регистратор
      can :manage, :all
      can :manage, Doctor
      can :manage, AssignedTest
      can :manage, TestMode
      can :manage, Doctor
      can :manage, LpuDbf
      can :manage, OfficfunDbf
      can :manage, SpeclistDbf
      can :manage, PostDbf
      can [:profile, :view_test_results, :profile, :modes_history,
           :generate_token, :clean_token, :save_pdf, :custom_create, :test_persons], User
    elsif user.role? :Методолог
      can :manage, :all
      can :manage, Test
      can :manage, Task
      can :manage, Answer
      can :manage, Association
      can :manage, TaskContent
      can [:index, :show], TestGroup
      can :manage, Section
      can :manage, Eqvgroup
      can :manage, Chain
      can :manage, Try
      can :manage, UserAssociation
      can :manage, UserAnswer
      can :manage, TaskResult
      can [:profile], User
    elsif user.role? :Тестируемый
      can :manage, Try
      can :manage, UserAssociation
      can :manage, UserAnswer
      can :manage, TaskResult
      can [:testee_tab], User
    elsif user.new_record?
      can [:token_auth, :check_token], User
    end
  end
end
