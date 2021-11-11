class AdditionalMessagesController < ApplicationController
  def index
    @room = Room.find(params[:room_id])
    authorize @room, policy_class: AdditionalMessagePolicy
    first = params[:message_count].to_i
    last = first + 49
    @messages = @room.messages.includes(:user).order(id: :DESC)[first..last].reverse
  end
end
