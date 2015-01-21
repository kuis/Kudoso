class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    can :create, User
    can :create, MyTodo
    if user.admin?
      can :manage, :all
    else
      if user.member.present? && user.member.parent?
        can [:read, :update], Family do |family|
          user.try(:family) == family
        end
        can :manage, Device do |device|
          device.try(:family) == user.family
        end
        can :manage, FamilyActivity do |famact|
          famact.try(:family) == user.family
        end
        can :manage, Member do |family_member|
          family_member.try(:family) == user.family
        end
        can :manage, Todo,  :family_id => user.try(:family_id)
        can :manage, TodoSchedule do |ts|
          if ts.present? && ts.todo.present?
            ts.todo.family == user.family
          else
            false
          end
        end
        can :manage, MyTodo do |todo|
            todo.member && user.family && todo.member.family == user.family
        end
        can :read, TodoTemplate, :active => true
        can :read, TodoGroup, :active => true
        can :assign, TodoGroup
      else
        # Child permissions
      end
      can :manage, MyTodo do |todo|
        todo.try(:member) == user
      end
      cannot :index, Family
    end



    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
