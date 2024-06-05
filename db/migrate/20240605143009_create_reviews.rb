class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :movie_id
      t.string :user
      t.integer :stars
      t.text :review

      t.timestamps
    end
  end
end
