class Ability
  include CanCan::Ability
  attr_accessor :user

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    @user = user
    if user
      if user.admin?
        admin_abilities
      else
        user_abilities
      end
    else
      guest_abilities

    end




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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    # can :create, [Question, Answer]
    # can :update, [Question, Answer], user_id: user.id
    # can :destroy, [Question, Answer], user_id: user.id
    can :manage, [Question, Answer], user_id: user.id
  end
end
