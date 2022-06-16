class FlatUsersController < ApplicationController
  def update
  end

  def create
  end

  def index
    @user = User.find(params[:id])
    @chores = @user.chore_lists
  end

  private

  def flat_user_review_params
    params.require(:flat_user).permit(:user_id, :flat)
  end
end
