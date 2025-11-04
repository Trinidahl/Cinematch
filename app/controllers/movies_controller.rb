class MoviesController < ApplicationController

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @chat.movie = @movie
    @movie.save
  end

  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # Affichage normal de la page
      format.js   # Réponse JavaScript pour la modale
    end
  end

  def index
    @movies = Movie.all
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :year, :director, :genre, :country, :description, :rank, :url, :unchosen, :system_prompt)
  end
end
