class MoviesController < ApplicationController
  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.save
  end

  def index
    @chat = Chat.find(params[:chat_id])
    @movies = Movie.where(chat: @chat)
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :year, :director, :genre, :country, :description, :rank, :url, :unchosen, :system_prompt)
  end
end
