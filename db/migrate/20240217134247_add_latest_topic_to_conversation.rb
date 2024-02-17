class AddLatestTopicToConversation < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :latest_topic, :string
  end
end
