class PreferencesController < ApplicationController
  def index
    @flat = FlatUser.where(user: current_user, active: true)
    to_create_prefs = current_user.find_chores_where_pref_not_exist
    current_user.create_pref_for_chores(to_create_prefs) if to_create_prefs.present?
    @preferences = current_user.preferences.order(:id)
  end

  def update
    @preference = Preference.find(params[:id])
    @preference.update(pref_params)
    @preferences = current_user.preferences.order(:id)
    flash[:notice] = "Your preference has been saved"
    # respond_to do |format|
    #   #format.text #{ render partial: "chores/chore", locals: { chore: @chore }, formats: [:html] }
    #   format.html #{ redirect_to preferences_path, status: 303, formats: [:html], via: [:get] }
    #   format.text #{ redirect_to preferences_path, status: 303, formats: [:html], via: [:get] }
    #   format.json
    # end
  end

  private

  def pref_params
    params.require(:preference).permit(:rating, :user_id, :chore_id)
  end
end
