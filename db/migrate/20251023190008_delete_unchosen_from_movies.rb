class DeleteUnchosenFromMovies < ActiveRecord::Migration[7.1]
  def change
    remove_column :movies, :unchosen, :boolean
  end
end
