class ChoresController < ApplicationController

  def index
  end

  def new
  end

  def create
    @flat = Flat.find(params[:id])
    @chore = Chore.new(chore_params)
    @chore.flat = @flat

    respond_to do |format|
      if @chore.save
        format.json
      else
        format.html { render "restaurants/show" }
        format.json # Follow the classic Rails flow and look for a create.json view
      end
    end
  end

  def setup
    @flat = Flat.find(params[:id])
    @chores = @flat.chores
    @chore = Chore.new
  end

  private

  def chore_params
    params.require(:chore).permit(:name, :repetition, :frequency, :duration)
  end
end
