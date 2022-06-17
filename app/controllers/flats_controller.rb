class FlatsController < ApplicationController

  def home
    @flat = Flat.new

    # Redirect user if user status is active
    @flat_user = FlatUser.where(user: current_user, active: true).first
    @flat_users = FlatUser.all

    if @flat_user && current_user.preferences.empty?
      # redirect to chore_list index page
      redirect_to preferences_path()
    elsif @flat_user && current_user.preferences.empty? == false
      redirect_to chore_list_index_path()
    end
  end

  def create
    # Should create new flat
    @flat = Flat.new(flat_params)

    if @flat.save
      redirect_to add_flatmates_to_flat_path(@flat)
      flat_user = FlatUser.new(flat: @flat, user: current_user)
      flat_user.active = true
      flat_user.save!
    else
      render :home
    end
  end

  def add_flatmates
    @roommate = User.new()
    # @flat_user.user = User.where(name: "kenny")
    # pass this. flat/id/user -> user create
    @flat = Flat.find(params[:id])
    # Find all users that belongs to the same flat instance
    @users = @flat.users
  end

  def show
    @users = Flat.find(params[:id]).users
    @flat = Flat.find(params[:id])
    @date = Time.now
  end

  def edit
    @flat = Flat.find(params[:id])
    @roommate = User.new()
    @users = @flat.users
  end

  def update
    @flat = Flat.find(params[:id])
    @flat.update(flat_params)
    redirect_to edit_flat_path
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
