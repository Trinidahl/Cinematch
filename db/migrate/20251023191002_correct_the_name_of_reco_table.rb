class CorrectTheNameOfRecoTable < ActiveRecord::Migration[7.1]
  def change
    rename_table :recomendations, :recommendations
  end
end
