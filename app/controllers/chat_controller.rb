class ChatController < ApplicationController
  def index
    @channels = SlackApiWrapper.list_channels
  end

  def new
    @channel = params[:channel]
  end

  def create
    message = params[:message]
    channel = params[:channel]

    if SlackApiWrapper.send_msg(channel, message)
      flash[:status] = :success
      flash[:message] = "Message sent to channel #{channel}!"
      redirect_to chat_new_path(channel)
    else
      flash[:status] = :failure
      flash[:message] = "It's not the most urgent thing in the world, but there was an issue with your message and it wasn't sent."
      render :new
    end

  end
end
