class PreferencesController < ApplicationController
  def index
    @flat = FlatUser.where(user: current_user, active: true)
    to_create_prefs = current_user.find_chores_where_pref_not_exist
    if to_create_prefs.present?
      current_user.create_pref_for_chores(to_create_prefs)
    end
    @preferences = current_user.preferences
  end

  def update
  end
end
