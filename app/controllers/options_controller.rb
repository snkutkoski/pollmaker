class OptionsController < ApplicationController

  # POST /options/:id/vote
  def vote
    respond_to do |format|
      format.json do
        OptionsService.vote(params[:id])
        render json: {message: 'Vote cast'}, status: 200
      end
    end
  end
end
