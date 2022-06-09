class PreferencesController < ApplicationController
  def index
    @flat = FlatUser.where(user: current_user, active: true)
  end

  def update
  end
end
