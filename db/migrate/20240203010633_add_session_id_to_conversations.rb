class AddSessionIdToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :session_id, :string, limit: 32, null: false
  end
end
