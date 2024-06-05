require 'csv'

class ImportMovieCsvJob < ApplicationJob
  queue_as :default

  def perform(csv_file)
    CSV.foreach(csv_file, headers: true) do |row|
      row = row.to_hash
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
  end
end
