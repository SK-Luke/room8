class FlatUsersController < ApplicationController
  def update
  end

  def create
    # @flat_user = FlatUser.new()
    # @user = User.find_by(email: flat_user_review_params[:user_id])
    # @flat = Flat.find(flat_user_review_params[:flat])

    # @flat_user.user = @user 
    # @flat_user.flat = @flat

    # if @flat_user.save
    #   redirect_to add_flatmates_to_flat_path(@flat)
    # else
    #   # flash[:notice] = "Invalid email"
    #   render "flats/add_flatmates"
    # end
  end

  private

  def flat_user_review_params
    params.require(:flat_user).permit(:user_id, :flat)
  end
end
