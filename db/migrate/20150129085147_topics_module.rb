class TopicsModule < ActiveRecord::Migration
  def change
    create_table :group_topics do |t|
      t.string :title
      t.text :message
      t.integer :views, default: 0
      t.belongs_to :user
      t.belongs_to :group

      t.timestamps
    end

    create_table :group_comments do |t|
      t.text :message
      t.belongs_to :user
      t.belongs_to :topic

      t.timestamps
    end
  end
end