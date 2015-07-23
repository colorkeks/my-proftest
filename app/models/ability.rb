class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can [:profile], User
    can :manage, Avatar
    can [:show, :edit, :update, :personal_info], User do |current_user|
      user.id == current_user.id
    end
    if user.role? :Супер_Администратор
      can :manage, :all
    end
    if user.role? :Администратор
      can :manage, Doctor
      can [:edit, :update, :test_persons], User
    end
    if user.role? :Регистратор
      can :manage, Doctor
      can :manage, AssignedTest
      can :manage, TestMode
      can :manage, Doctor
      can :manage, LpuDbf
      can :manage, OfficfunDbf
      can :manage, SpeclistDbf
      can :manage, PostDbf
      can [:view_test_results, :profile, :modes_history,
           :generate_token, :clean_token, :save_pdf, :custom_create,
           :test_persons, :print_test_results], User
    end
    if user.role? :Методолог
      can :manage, TestGroup
      can :manage, Test
      can :manage, Task
      can :manage, Answer
      can :manage, Association
      can :manage, TaskContent
      can :manage, Section
      can :manage, Eqvgroup
      can :manage, Chain
      can :manage, Try
      can :manage, UserAssociation
      can :manage, UserAnswer
      can :manage, TaskResult
    end
    if user.role? :Тестируемый
      can :manage, Try
      can :manage, UserAssociation
      can :manage, UserAnswer
      can :manage, TaskResult
      can [:testee_tab], User
    end
    if user.new_record?
      can [:token_auth, :check_token], User
    end
  end
end
