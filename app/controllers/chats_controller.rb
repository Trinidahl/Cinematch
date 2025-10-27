SYSTEM_PROMPT = "
  You are a movie recommendation assistant.
  You help users find the perfect movie based on their mood, preferred genre,
  country, and other preferences. Provide thoughtful recommendations with explanations.
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
  end

  def new
  end

  def create
    # Crée le chat
    @chat = current_user.chats.build(chat_params)

    if @chat.save
      # Crée le premier message avec le contenu du formulaire
      @user_message_content = build_user_message

      @message = @chat.messages.create!(
        role: "user",
        content: @user_message_content
      )

      # Appel du LLM
      @ruby_llm_chat = RubyLLM.chat
      response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)

      # Crée la réponse
      @chat.messages.create!(
        role: "assistant",
        content: response.content
      )

      # Redirige vers la page du chat
      redirect_to chat_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

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
