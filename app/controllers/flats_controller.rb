class FlatsController < ApplicationController

  def home
    @flat = Flat.new

    # Redirect user if user status is active
    @flat_user = FlatUser.where(user: current_user, active: true).first
    if @flat_user
      # redirect to chore_list index page
      redirect_to chore_list_index_path()
    end
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
    @users = Flat.find(params[:id]).users
  end

  def edit
  end

  def update
  end

  def validate_flatmate
    # @flat = current_user
    # raise 
  end

  private

  def flat_params
    params.require(:flat).permit(:name)
  end
end
