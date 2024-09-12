class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :name
      t.integer :amount
      t.string :address
      t.string :tel
      t.string :others
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
