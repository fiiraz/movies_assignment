namespace :import do
  desc "Import movies and reviews from CSV files"
  task :csv => :environment do
    require "csv"

    movies_file = Rails.root.join("lib", "data", "movies.csv")
    reviews_file = Rails.root.join("lib", "data", "reviews.csv")

    # Import movies
    movies_data = {}
    CSV.foreach(movies_file, headers: true) do |row|
      title = row["Movie"]
      if movies_data[title].nil?
        movies_data[title] = {
          description: row["Description"],
          year: row["Year"],
          director: [row["Director"]],
          actors: [row["Actor"]],
          filming_location: [row["Filming location"]],
          country: row["Country"]
        }
      else
        movies_data[title][:director] << row["Director"]
        movies_data[title][:actors] << row["Actor"]
        movies_data[title][:filming_location] << row["Filming location"]
      end
    end

    Movie.transaction do
      movies_data.each do |title, data|
        Movie.create!(
          title: title,
          description: data[:description],
          year: data[:year],
          director: data[:director].uniq.join(", "),
          actor: data[:actors].uniq.join(", "),
          filming_location: data[:filming_location].uniq.join(", "),
          country: data[:country]
        )
      end
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
