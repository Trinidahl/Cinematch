SYSTEM_PROMPT = "
  You are a movie recommendation assistant.
  You help users find the perfect movie based on their mood, preferred genre,
  country, and other preferences. Provide thoughtful recommendations with explanations.
"

class ChatsController < ApplicationController
  def index
    @chats = Chat.all
  end

  def show
    @chat = Chat.find(params[:id])
    @movies = @chat.movies.where(recommendations: { unchosen: false })
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
    params.require(:chat).permit(:title, :status)
  end

  def build_user_message
    # À adapter après finalisation du formulaire, je mets des données en dur pour le moment
    # mood = params[:mood]
    # genre = params[:genre]
    # country = params[:country]
    # etc

    # réponses au formulaire à interpoler ici
    "I'm looking for a movie with the following criteria:
    - Mood: feel good
    - Genre: comedy
    - Country: france
    - Year: between 2000 and 2025
    - Director: no preferences

    Can you recommend some movies?"
  end
end
