class CreateQuesFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :ques_favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
      t.index [:user_id, :question_id], unique: true
    end
  end
end
