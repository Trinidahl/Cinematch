class MessagesController < ApplicationController
  before_action :set_chat

  def create
    # Créer le message de l'utilisateur
    @message = @chat.messages.build(message_params)
    @message.role = "user"

    if @message.save
      # TODO: Appeler le LLM et créer la réponse
      # Pour l'instant on redirige juste vers le chat
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
