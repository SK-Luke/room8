class FlatsController < ApplicationController

  def home
    @flat = Flat.new
  end

  def create
    # Should create new flat
    @flat = Flat.new(flat_params)

    if @flat.save
      redirect_to add_flatmates_to_flat_path(@flat)
    else
      render :home
    end
    flat_user = FlatUser.new(flat: @flat, user: current_user)
    flat_user.save
  end

  def add_flatmates
  end

  def show
    @users = Flat.find(params[:flat_id]).users
  end

  def edit
  end

  def update
  end

  private

  def flat_params
    params.require(:flat).permit(:name)
  end
end
