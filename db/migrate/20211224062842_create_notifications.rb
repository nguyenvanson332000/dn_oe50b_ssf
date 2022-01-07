class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :recipient_id
      t.integer :actor_id
      t.string :notice_type
      t.string :title
      t.string :content
      t.datetime :checked

      t.timestamps
    end
  end
end
