class ChoresController < ApplicationController

  def index
    @flat = Flat.find(params[:id])
    @chores = @flat.chores
    @chore = Chore.new()
    @highlight = false
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
        @chore.create_pref_for_all_users
        format.json # do not remove this
      else
        format.json # do not remove
      end
    end
  end

  def setup
    @flat = Flat.find(params[:id])
    # @chores = Chore.defaults
    @chores = @flat.chores
    @chore = Chore.new
    @highlight = true
  end

  def destroy
    @chore = Chore.find(params[:id])
    @chore.destroy
    #redirect_to "/flats/#{@flat.id}/chores"
    respond_to do |format|
      format.json { { status: "ok" } }
    end
  end

  private

  def chore_params
    params.require(:chore).permit(:name, :repetition, :frequency, :duration)
  end
end
