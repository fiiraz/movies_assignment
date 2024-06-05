require 'csv'

class ImportReviewCsvJob < ApplicationJob
  queue_as :default

  def perform(csv_file)
    CSV.foreach(csv_file, headers: true) do |row|
      row = row.to_hash
      movie = Movie.find_by(title: row["Movie"])
      Review.create!(
        movie_id: movie.id,
        user: row["User"],
        stars: row["Stars"],
        review: row["Review"]
      ) if movie.present?
    end
  end
end
