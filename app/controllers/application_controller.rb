class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id] || params[:id])
  end
end
