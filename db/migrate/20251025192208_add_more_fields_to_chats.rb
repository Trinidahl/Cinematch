class AddMoreFieldsToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :realisator, :string
    add_column :chats, :year, :integer
    add_column :chats, :country, :string
    add_column :chats, :length, :integer
  end
end
