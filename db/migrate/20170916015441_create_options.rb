class CreateOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :options do |t|
      t.string :name
      t.belongs_to :polls, foreign_key: true, null: false
      t.integer :vote_count, null: false, default: 0
      t.timestamps
    end
  end
end
