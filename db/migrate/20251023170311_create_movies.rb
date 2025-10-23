class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :year
      t.string :director
      t.string :genre
      t.string :country
      t.text :description
      t.integer :rank
      t.string :url
      t.string :image
      t.boolean :unchosen
      t.string :system_prompt

      t.timestamps
    end
  end
end
