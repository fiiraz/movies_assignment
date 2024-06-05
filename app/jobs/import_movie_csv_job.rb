require 'csv'

class ImportMovieCsvJob < ApplicationJob
  queue_as :default

  def perform(csv_file)
    movies_data = {}
    CSV.foreach(csv_file, headers: true) do |row|
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

    # Create movie entries in the database
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
  end
end
