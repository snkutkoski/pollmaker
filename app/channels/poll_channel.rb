class PollChannel < ApplicationCable::Channel
  def subscribed
    stream_from "poll_#{params[:id]}"
  end
end
