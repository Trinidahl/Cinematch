class ChatsController < ApplicationController
  def index
    @chats = Chat.all
  end

  def show
    @movies = Movie.find(recommendations: { unchosen: false })
  end

  def create
  end
end
