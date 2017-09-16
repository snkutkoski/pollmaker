class PollsController < ApplicationController

  # POST /polls
  def create
    poll = PollsService.create(poll_params)

    respond_to do |format|
      format.json do
        render json: poll.as_json(include: :options), status: poll.valid? ? 201 : 422
      end
    end
  end

  private

  def poll_params
    params.require(:poll).permit(:question, options: [:name])
  end
end
