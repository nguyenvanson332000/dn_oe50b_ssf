class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :soccer_field, null: false, foreign_key: true
      t.integer :rating
      t.integer :parent_id
      t.text :content

      t.timestamps
    end
  end
end
