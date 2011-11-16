class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new
    
    if user.teacher?
      can :manage, Assignment
      can :manage, Grade
      can :manage, Course
    elsif user.student?
      can :turn_in, Assignment
      can :index, Assignment
      can :show, Assignment
      can :index, Grade
      can :update, Grade
      can :show, Grade
      can :create, Grade
      can :index, Course
      can :show, Course
      can :join, Course
      can :leave, Course
    end
  end
end
