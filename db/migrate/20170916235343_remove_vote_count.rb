class RemoveVoteCount < ActiveRecord::Migration[5.1]
  def change
    remove_column :options, :vote_count, :integer, default: 0, null: false
  end
end
