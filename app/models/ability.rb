class Ability < DefineAbility

  protected

  def define!(user)
    unless user.nil?
      group_permissions(user)
    end
  end

  private

  def group_permissions(user)
    module_name :group do
      create_and_comment_topics = lambda do |group|
        group.can?(:write, :topic, user)
      end
      edit_comment_and_topics = lambda do |group, topic_or_comment|
        group.can?(:write, :topic, user) or topic_or_comment.user_id == user.id
      end
      destroy_comment_and_topics = lambda do |group, topic_or_comment|
        group.can?(:delete, :topic, user) or topic_or_comment.user_id == user.id
      end
      manage_invitations = lambda do |group|
        group.can? :manage, :invitations, user
      end

      controller :topics do
        can([:index, :show]) do |group|
          group.can? :index, :topics, user
        end
        can([:edit, :update], &edit_comment_and_topics)
        can([:create, :new], &create_and_comment_topics)
        can(:destroy, &destroy_comment_and_topics)
      end

      controller :comments do
        can(:create, &create_and_comment_topics)
        can [:edit, :update], &edit_comment_and_topics
        can :destroy, &destroy_comment_and_topics
      end

      controller :invitations do
        can([:index, :destroy], &manage_invitations)
        can(:create) do |group|
          group.can? :create, :invitation, user
        end
        can(:update) do |invitation|
          invitation.receiver_id == user.id
        end
      end

      controller :email_invitations do
        can(:destroy, &manage_invitations)
        can [:confirm, :update]
      end

      controller :groups_creator do
        can(:invitations) do |group|
          user.id == group.user_id
        end
      end

      controller :admin do
        can(:index)
      end

      controller :members do
        can(:index) do |group|
          group.can? :index, :members, user
        end
        can :update
      end

      controller :groups do
        can(:show) do |group|
          group.can? :index, :activity, user
        end
        can(:invitations) do |group|
          group.user_id == user.id
        end
      end
    end
  end
end