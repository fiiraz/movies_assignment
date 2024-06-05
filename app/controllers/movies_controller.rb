class MoviesController < ApplicationController
  def index
    if params[:actor].present?
      @movies = Movie.where("actor LIKE ?", "%#{params[:actor]}%")
                     .with_average_stars.order('average_stars DESC')
    else
      @movies = Movie.with_average_stars.order('average_stars DESC')
    end
  end
end
