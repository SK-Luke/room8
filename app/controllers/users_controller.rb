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
    @flat_user.save!

    if @flat_user.save
      redirect_to add_flatmates_to_flat_path(@flat)
    else
      # flash[:notice] = "Invalid email"
      render "flats/add_flatmates"
    end
  end

  private

  def user_review_params
    params.require(:user).permit(:email, :flat)
  end
end
