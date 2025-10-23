class CreateRecomendations < ActiveRecord::Migration[7.1]
  def change
    create_table :recomendations do |t|
      t.boolean :unchosen
      t.references :chat, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
