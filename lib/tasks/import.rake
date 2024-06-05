namespace :import do
  desc "Import movies and reviews from CSV files"
  task :csv => :environment do
    require "csv"

    movies_file = Rails.root.join("lib", "data", "movies.csv")
    reviews_file = Rails.root.join("lib", "data", "reviews.csv")

    # Import movies
    CSV.foreach(movies_file, headers: true) do |row|
      Movie.create(
        title: row["Movie"],
        description: row["Description"],
        year: row["Year"],
        director: row["Director"],
        actor: row["Actor"],
        filming_location: row["Filming location"],
        country: row["Country"]
      )
    end

    # Import reviews
    CSV.foreach(reviews_file, headers: true) do |row|
      movie = Movie.find_by(title: row["Movie"])
      Review.create(
        movie_id: movie.id,
        user: row["User"],
        stars: row["Stars"],
        review: row["Review"]
      ) if movie.present?
    end
  end
end
