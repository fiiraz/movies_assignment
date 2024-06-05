class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :title, :description, :year, :director,
            :actor, :filming_location, :country, presence: true


  attr_accessor :average_stars

  scope :with_average_stars, -> {
    left_joins(:reviews)
      .select('movies.*, COALESCE(AVG(reviews.stars), 0) AS average_stars')
      .group('movies.id')
      .order('average_stars DESC')
  }
end
