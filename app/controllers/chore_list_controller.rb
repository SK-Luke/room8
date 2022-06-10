class ChoreListController < ApplicationController
  def index
    @chorelist = ChoreList.all
    
    # see if user is looking at himself or other people's chore``
    if params[:username].nil?
      @user = current_user
    else
      @user = User.find_by_username(params[:username])
    end
  end

  def update

  end
end
