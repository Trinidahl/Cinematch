class DeleteImageFromMovie < ActiveRecord::Migration[7.1]
  def change
    remove_column :movie, :image, :string
  end
end
