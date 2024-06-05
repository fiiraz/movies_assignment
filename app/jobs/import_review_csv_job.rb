require 'csv'

class ImportReviewCsvJob < ApplicationJob
  queue_as :default

  def perform(csv_file)
    batch_size = 1000

    CSV.foreach(csv_file, headers: true).each_slice(batch_size) do |rows|
      Review.transaction do
        rows.each do |row|
          row = row.to_hash
          movie = Movie.find_by(title: row["Movie"])

          next unless movie.present?

          Review.create!(
            movie_id: movie.id,
            user: row["User"],
            stars: row["Stars"],
            review: row["Review"]
          )
        end
      end
    end
  end
end
