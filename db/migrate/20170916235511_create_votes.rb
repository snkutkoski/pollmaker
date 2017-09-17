class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.belongs_to :option, foreign_key: true, null: false
      t.timestamps
    end
  end
end
