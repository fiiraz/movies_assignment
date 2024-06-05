class Review < ApplicationRecord
  belongs_to :movie

  validates :user, :stars, :review, presence: true
  validates :stars, inclusion: { in: 1..5 }
end
