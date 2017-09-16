class PollsController < ApplicationController

  # POST /polls
  def create
    poll = PollsService.create(poll_params)

    respond_to do |format|
      format.json do
        render json: poll_json(poll), status: poll.valid? ? 201 : 422
      end
    end
  end

  # GET /polls/:id
  def show
    poll = PollsService.find(params[:id])

    respond_to do |format|
      format.json do
        if poll
          render json: poll_json(poll)
        else
          render json: {message: "Could not find poll with id #{params[:id]}"}, status: 404
        end
      end
    end
  end

  private

  def poll_params
    params.require(:poll).permit(:question, options: [:name])
  end

  def poll_json(poll)
    poll.as_json(include: :options)
  end
end
