class RecommendationsController < ApplicationController
  before_action :set_chat

  def create
    # 1. Parser les données du film envoyées depuis la vue
    #    Et transformer la string JSON en Hash pour qu'active record l'interprète
    movie_data = JSON.parse(params[:movie_data])

    # 2. Créer ou trouver le movie dans la table movies
    # pour reference sur find_or_create_by: https://guides.rubyonrails.org/active_record_querying.html#find-or-create-by
    @movie = Movie.find_or_create_by(title: movie_data['title']) do |movie|
      movie.year = movie_data['year']
      movie.director = movie_data['director']
      movie.genre = movie_data['genre']
      movie.country = movie_data['country']
      movie.description = movie_data['description']
      movie.img_url = movie_data['image_url']  # Sauvegarde l'URL de l'image
    end

    # 3. Créer la recommendation (lien entre chat et movie)
    @recommendation = Recommendation.find_or_create_by(
      chat: @chat,
      movie: @movie
    ) do |recommendation|
      recommendation.unchosen = false # Le film est choisi/sauvegardé
    end

    # 4. Rediriger avec un message de succès
    redirect_to chat_path(@chat), notice: "Movie saved successfully!"
  end
end
