class CreateGroupModule < ActiveRecord::Migration
  def change
    create_table :group_groups do |t|
      t.string :name
      t.text :description

      t.string :steps
      t.boolean :is_finished, default: false

      t.string :can_index_activity
      t.string :can_delete_group
      t.string :can_read_topic
      t.string :can_index_members
      t.string :can_read_member
      t.string :can_delete_member
      t.string :can_write_file
      t.string :can_index_files
      t.string :can_read_file
      t.string :can_delete_file
      t.string :can_index_topics
      t.string :can_write_topic
      t.string :can_delete_topic
      t.string :can_create_invitation
      t.string :can_manage_invitations

      t.belongs_to :user

      t.timestamps
    end

    create_table :group_group_members do |t|
      t.belongs_to :group, index: true
      t.belongs_to :user, index: true
      t.string :role
      t.string :joined_method
      t.belongs_to :invited_or_added_by, index: true

      t.timestamps
    end

    create_table :group_invitations do |t|
      t.text :message
      t.string :status

      t.belongs_to :sender, index: true
      t.belongs_to :group, index: true
      t.belongs_to :receiver, index: true


      t.timestamps
    end

    create_table :group_email_invitations do |t|
      t.string :email
      t.text :message
      t.string :secret_token
      t.string :status
      t.belongs_to :group
      t.belongs_to :user
    end

  end
end
