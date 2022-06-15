class ChoreListController < ApplicationController
  def index
    # see if user is looking at himself or other people's chore``
    if params[:name].nil?
      @user = current_user
    else
      @user = User.find_by_name(params[:name])
    end
    @chorelists = []
    @incomplete = []
    @to_do = []
    @completed = []
    @upcoming = []
    set_chore_listings
    distribute_cards
  end

  def update
    if params[:chore_list].blank?
      mark_chore_complete
    else
      params.permit(:id)
      @task = ChoreList.find(params[:id])
      @task.update(params.require(:chore_list).permit(:deadline))
      respond_to do |format|
        format.text { render partial: "chore_list/edit_deadline", locals: { task: @task }, formats: [:html] }
        format.json
      end
    end
  end

  private

  def set_chore_listings
    # Need to add in time condition next
    listings = @user.chore_lists.order(:deadline)
    listings.each do |item|
      @chorelists << item.chore
    end
    @chorelists = @chorelists.group_by(&:name)
  end

  def distribute_cards
    @chorelists = @chorelists.values
    @chorelists.each do |arr|
      i = 0
      # Check if completed, if yes -> completed
      # If no, check deadline, If overdued, -> incomplete
      # if not due -> to do, the rest go upcoming
      while i < arr.length
        if arr[i].chore_lists.first.complete
          @completed << arr[i].chore_lists.first
          i += 1
        elsif arr[i].chore_lists.first.deadline < DateTime.now
          @incomplete << arr[i].chore_lists.first
          i += 1
        elsif arr[i].chore_lists.first.deadline > DateTime.now
          @to_do << arr[i].chore_lists.first
          i += 1
          # If nested while doesn't work, use until
          while i < arr.length
            @upcoming << arr[i].chore_lists.first
            i += 1
          end
        end
      end
    end
  end

  def get_days(y, m, d)
    # this should return us days remaining to end of month
    # check if is created < 7 to end of month
    # total_days && days_to_eom returns an integer
    @days_to_eom = Date.new(y , m, -1).day - DateTime.now.day
    if days_to_eom <= 7
      # get next month days
      @total_days = Date.new(y, m + 1, -1).day if m < 12
      @total_days = Date.new(y + 1, 1, -1).day if m == 12
    else
      # get this month remaining days
      @total_days = Date.new(y, m, -1).day - DateTime.now.day
    end
  end

  def total_flats_chores
    # Get array of total chores
    total_chores = current_user.flat_users.find_by(active: true).flat.chores
    # For each chore, calculate the gap (freq / rate)
    total_chores.each do |c|
      # If daily, is within hours
      # If weekly/monthly, is within days
      if c.frequency == "daily"
        # This will return gap in terms of hours
        gap = (24 / c.repetition).hours
      elsif c.frequency == "weekly"
        # This will return a float value in days
        gap = 7.fdiv(c.repetition).days
      elsif c.frequency == "monthly"
        # Need check if is current month distributing or next month,
        # as we may have months of different dates
        # Take reference from days
        # This should return gap in days
        gap = @total_days.fdiv(c.repetition).days if @days_to_eom <= 7
        gap = Date.new(Date.today.year, Date.today.mon, -1).day.days if @days_to_eom > 7
      end
    end
    # Find last occurence of chore
    # offset gap
  end


  def mark_chore_complete
    params.permit(:id)
    @task = ChoreList.find(params[:id])
    @task.complete = true
    respond_to do |format|
      if @task.save
        format.html { redirect_to chore_list_index_path }
        format.json # Follow the classic Rails flow and look for a create.json view
      else
        format.html { render "chore_list" }
        format.json # Follow the classic Rails flow and look for a create.json view
      end
    end
  end
end
