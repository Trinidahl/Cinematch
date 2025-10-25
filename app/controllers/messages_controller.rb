class MessagesController < ApplicationController
  before_action :set_chat

  def create
    # Crée le message de l'utilisateur
    @message = @chat.messages.build(message_params)
    @message.role = "user"

    if @message.save
      # Appelle le LLM et crée la réponse
      @ruby_llm_chat = RubyLLM.chat
      response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)

      #Crée la réponse
      @chat.messages.create!(
        role: "assistant",
        content: response.content
      )

      redirect_to chat_path(@chat)

    else
      # En cas d'erreur on redirige avec un message
      redirect_to chat_path(@chat), alert: "Error sending message"
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
