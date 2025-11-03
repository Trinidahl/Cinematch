require 'open-uri'
require 'json'

class MessagesController < ApplicationController
  before_action :set_chat

  def create
    # Crée le message de l'utilisateur
    @message = @chat.messages.build(message_params)
    @message.role = "user"

    if @message.save
      # Appelle le LLM et crée la réponse
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)

      enriched_response = enrich_with_omdb(response.content)

      # Crée SEULEMENT le message assistant
      @chat.messages.create!(role: "assistant", content: enriched_response)

      respond_to do |format|
        format.turbo_stream # renders `app/views/messages/create.turbo_stream.erb`
        format.html { redirect_to chat_path(@chat) }
      end

    else
      # En cas d'erreur on redirige avec un message
      redirect_to chat_path(@chat), alert: "Error sending message"
    end
  end

  private

  def build_conversation_history
    @ruby_llm_chat = RubyLLM.chat
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content)
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
end
