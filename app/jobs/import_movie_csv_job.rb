require 'csv'

class ImportMovieCsvJob < ApplicationJob
  queue_as :default

  def perform(csv_file)
    batch_size = 1000

    CSV.foreach(csv_file, headers: true).each_slice(batch_size) do |rows|
      Movie.transaction do
        rows.each do |row|
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
  end
end
