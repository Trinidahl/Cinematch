class AddFieldsToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :mood, :string
    add_column :chats, :genre, :string
    add_column :chats, :actor, :string
  end
end
