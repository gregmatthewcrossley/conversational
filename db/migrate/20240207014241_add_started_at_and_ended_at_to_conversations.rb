class AddStartedAtAndEndedAtToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :started_at, :datetime
    add_column :conversations, :ended_at, :datetime
  end
end
