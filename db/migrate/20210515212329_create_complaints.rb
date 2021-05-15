class CreateComplaints < ActiveRecord::Migration[6.1]
  def change
    create_table :complaints do |t|
      t.text :description
      t.integer :status, default: 0
      t.float :lat
      t.float :long
      t.string :address
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
