class DeleteImageFromMovie < ActiveRecord::Migration[7.1]
  def change
    remove_column :movies, :image, :string
  end
end
