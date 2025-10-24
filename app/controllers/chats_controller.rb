class ChatsController < ApplicationController
  def index
    @chats = Chat.all
  end

  def show
    @chat = Chat.find(params[:id])
    @movies = @chat.movies.where(recommendations: { unchosen: false })
  end

  def create
  end
end
