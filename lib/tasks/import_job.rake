namespace :import_job do
  task :data => :environment do
    # ImportCsvDataJob.perform_now("lib/data/movies.csv", "Movie")
    # ImportCsvDataJob.perform_now("lib/data/reviews.csv", "Review")
    ImportMovieCsvJob.perform_now("lib/data/movies.csv")
    ImportReviewCsvJob.perform_now("lib/data/reviews.csv")
  end
end
