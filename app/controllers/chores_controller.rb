class ChoresController < ApplicationController

  def index
    @flat = Flat.find(params[:id])
    @chores = @flat.chores
    @chore = Chore.new()
  end

  def update
    @chore = Chore.find(params[:id])
    @chore.update(chore_params)

    respond_to do |format|
      format.text { render partial: "chores/chore", locals: { chore: @chore }, formats: [:html] }
      format.json
    end
  end

  def create
    @flat = Flat.find(params[:id])
    @chore = Chore.new(chore_params)
    @chore.flat = @flat

    respond_to do |format|
      if @chore.save
        format.json
      else
        format.json # Follow the classic Rails flow and look for a create.json view
      end
    end
  end

  def setup
    @flat = Flat.find(params[:id])
    @chores = @flat.chores
    @chore = Chore.new
  end

  def destroy
    @chore = Chore.find(params[:id])
    @chore.destroy
    redirect_to "/flats/#{@flat.id}/chores"
    respond_to do |format|
      format.json {{status: "ok"}}
    end
  end

  private

  def chore_params
    params.require(:chore).permit(:name, :repetition, :frequency, :duration)
  end
end
