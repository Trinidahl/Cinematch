class RenameUrlToImgUrlInMovies < ActiveRecord::Migration[7.1]
  def change
    rename_column :movies, :url, :img_url
  end
end
