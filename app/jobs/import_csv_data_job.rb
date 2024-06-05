require 'csv'

class ImportCsvDataJob < ApplicationJob
  queue_as :default

  def perform(csv_file, model_class)
    CSV.foreach(csv_file, headers: true) do |row|
      attrs = row.to_hash

      case model_class
      when "Movie"
        import_movies(attrs)
      when "Review"
        import_reviews(attrs)
      end
    end
  end

  def import_movies(row)
    Movie.create!(
      title: row["Movie"],
      description: row["Description"],
      year: row["Year"],
      director: row["Director"],
      actor: row["Actor"],
      filming_location: row["Filming location"],
      country: row["Country"]
    )
  end

  def import_reviews(row)
    movie = Movie.find_by(title: row["Movie"])
    Review.create!(
      movie_id: movie.id,
      user: row["User"],
      stars: row["Stars"],
      review: row["Review"]
    ) if movie.present?
  end
end
