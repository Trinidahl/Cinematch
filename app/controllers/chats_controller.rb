require 'open-uri'
require 'json'

SYSTEM_PROMPT = "
  You are a movie recommendation assistant.
  You help users find the perfect movie based on their mood, preferred genre,
  country, and other preferences.

  IMPORTANT: You must respond with a JSON array of movie recommendations.
  Each movie must have this exact structure:
  {
    \"title\": \"Movie Title\",
    \"year\": \"2020\",
    \"director\": \"Director Name\",
    \"genre\": \"Genre\",
    \"country\": \"Country\",
    \"description\": \"Short description (max 150 characters)\",
  }

  Return ONLY the JSON array, no additional text.
  Recommend 3-5 movies maximum.
"

class ChatsController < ApplicationController
  def index
    @chats = current_user.chats.all
    @chat = current_user.chats.build
  end

  def show
    @chat = Chat.find(params[:id])
    @movies = @chat.movies.where(recommendations: { unchosen: false })
    @messages = @chat.messages.order(created_at: :asc)
    # récupère les dernières recommendations
    @recommended_movies = extract_recommendations_from_last_message
  end

  def new
  end

  def create
    # Crée le chat
    @chat = current_user.chats.build(chat_params)

    if @chat.save
      @user_message_content = build_user_message
      @message = @chat.messages.create!(role: "user", content: @user_message_content)

      # Appel du LLM
      @ruby_llm_chat = RubyLLM.chat
      response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)

      # variable stockant la version enrichie de la réponse avec l'image du movie
      enriched_response = enrich_with_omdb(response.content)

      # Modifiée pour retourner la version enrichie
      @chat.messages.create!(role: "assistant", content: enriched_response)

      redirect_to chat_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def extract_recommendations_from_last_message
    last_assistant_message = @chat.messages.where(role: "assistant").last
    return [] unless last_assistant_message

    begin
      json_match = last_assistant_message.content.match(/\[.*\]/m)
      return [] unless json_match
      JSON.parse(json_match[0])
    rescue JSON::ParserError
      []
    end
  end

  # méthode permettant d'enrichir la réponse du LLM avec OMDB
  def enrich_with_omdb(llm_response)
    begin
      # parse la réponse JSON du LLM
      json_match = llm_response.match(/\[.*\]/m)
      return llm_response unless json_match

      movies = JSON.parse(json_match[0])

      # enrichit chaque film avec le poster OMDB
      enriched_movies = movies.map do |movie|
        omdb_data = fetch_from_omdb(movie['title'])
        movie['image_url'] = omdb_data['Poster'] if omdb_data && omdb_data['Poster'] != 'N/A'
        movie
      end

      enriched_movies.to_json
    rescue => e
      Rails.logger.error "Error enriching with OMDB: #{e.message}"
      llm_response # Retourner la réponse originale en cas d'erreur
    end
  end

  # appel à l'API OMDB
  def fetch_from_omdb(title)
    api_key = ENV['OMDB_API_KEY']
    url = "http://www.omdbapi.com/?apikey=#{api_key}&t=#{URI.encode_www_form_component(title)}"

    begin
      response = URI.open(url).read
      JSON.parse(response)
    rescue => e
      Rails.logger.error "OMDB API error for #{title}: #{e.message}"
      nil
    end
  end

  def chat_params
    params.require(:chat).permit(
      :title, :status,
      :mood, :genre, :actor,
      :realisator, :year, :country, :length
    )
  end

  def build_user_message
  mood = params[:chat][:mood].presence || "any"
  genre = params[:chat][:genre].presence || "any"
  actor = params[:chat][:actor].presence || "no preference"
  realisator = params[:chat][:realisator].presence || "no preference"
  year = params[:chat][:year].presence || "any year"
  country = params[:chat][:country].presence || "any country"
  length = params[:chat][:length].presence || "any length"

  <<~MESSAGE
    I'm looking for a movie with the following criteria:
    - Mood: #{mood}
    - Genre: #{genre}
    - Actor: #{actor}
    - Director: #{realisator}
    - Year: #{year}
    - Country: #{country}
    - Length: #{length} minutes or less (if applicable)

    Please recommend a few movies that match these preferences, with a short description for each.
  MESSAGE
  end
end
