class FlatsController < ApplicationController

  def home
    @flat = Flat.new
  end

  def create
    # Should create new flat
    @flat = Flat.create(flat_params)
    flat_user = FlatUser.new(flat: @flat, user: current_user)
    flat_user.save
  end

  def add_flatmates
  end

  def show
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
