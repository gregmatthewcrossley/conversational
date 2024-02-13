class AddProgramClassToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :program_class, :string
  end
end
