class UsersController < ApplicationController
  def edit
  end

  def update
  end

  def add_flat_user
    
    @roommate = User.new()
    @user = User.find_by(email: user_review_params[:email])
    @flat = Flat.find(user_review_params[:flat])
    
    @flat_user = FlatUser.new()
    @flat_user.user = @user
    @flat_user.flat = @flat
    @flat_user.active = true
    
    respond_to do |format|
      if @flat_user.save
        format.html { redirect_to add_flatmates_to_flat_path(@flat) }
        format.json {render json: @flat_user.user} # Follow the classic Rails flow and look for a create.json view
      else
        @flat_user = FlatUser.where(flat: @flat)
        format.html { render "flats/add_flatmates" }
        format.json # Follow the classic Rails flow and look for a create.json view
      end
    end
  end

  private

  def user_review_params
    params.require(:user).permit(:email, :flat)
  end
end
