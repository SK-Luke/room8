class FlatUsersController < ApplicationController
  def update
    raise
  end

  def create
    @flat_user = FlatUser.new()
    # @flat = Flat.find(params[:id])
  end
end
