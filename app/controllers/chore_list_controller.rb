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
    raise
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
    # @total_days = integer
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
    calc_gap(total_chores)
    # Here we will need to from gap, calculate the number of chore_list instance to create
    # Either I create a cl instance to iterate thru, or combine creation and iterate thru later.
    # Attempt to create first and store
    # If eom < 7 days, start_date is last_date + offset gap
    # If not, we just do today date + 1 as start date
    # The following takes into account of both offset gap and eom
    total_chores.each do |c|
      # Create an array to store the lists of chores
      @chore_lists_to_assign = []
      # Use total days / gap to get number of instance to create
      gap = @gap.find { |g| g[c.name] }
      # num = number of instances to create
      num = @total_days / gap
      # d = start_date
      last_chore = current_user.flat_users.find_by(active: true).flat.chores.find_by(name: Chore.first.name).chore_lists.last
      if last_chore.present?
        # This gives date of last chore
        d = last_chore.deadline
      else
        # this gives date of new chore, but we minus gap so the algo can apply the += gap
        d = DateTime.new(y, m + 1, 1) - gap if m < 12
        d = DateTime.new(y + 1, 1, 1) - gap if m == 12
      end
      # This will give us a new start_date, assuming changes will only be implemented next month
      for d in 1..num do
        # Create and assign chore, deadline, month, except for user
        @chore_lists_to_assign << ChoreList.new(deadline: deadline += gap, chore: c, month_list: MonthList.create(month:Date.today.next_month))
        # ChoreList.new(deadline: DateTime.now + 2.days, chore: Chore.first, month_list: MonthList.create(month: Date.today.next_month))
      end

    end


    # Start_date of first chore_list, and start_date of last occurence
    # Refer to calc_gap method, we can add gap and offset gap value inside the hash
    # Have a method to check if offset gap exist / 0 etc.
    # Conditional, if its just created mid of month, start_date = today + 1
    # If it is for next month schedule, start_date = first_day of next_month + offset gap
    # Since gap an all are calculated, everytime user edit and assign chores, it will auto tabulate, scalable
    # End of this method, I should get an array of total chore_lists that is group_by name

  end

  def assign_chores
    # From the array of hashes of chore_lists from total_flat chores, iterate through the algo
    # Has a preference converter method, for the above keys(chores), get user preference and add in like gap
    # Has chore_today? Actually does it matter now?
    # Total count of completed chores last month (from chore_listing methods), + this month chore_lists count, this is also CHORE TYPE SPECIFIC
    # Repeat the above for user specific, follow by flat, and div, rounded to 0.01 (up)
    # Rpeat the above 2 lines for total hours
    # Actually, do we even need this month value? Since theoretically this month clean slate everyone is equal, is only last month data that affects the distribution
  end

  def calc_gap(chores_array)
    @gap = []
    # After getting it, we should store it to a hash with key as title of chore / chore_id / instance
    # Value will be the gap
    # Create an array @gap to store hashes where key is chore name / instance, then gap is value
    chores_array.each do |c|
      # If daily, is within hours
      # If weekly/monthly, is within days
      # @gaps = [{"chore.name" => number.days}, {}]
      if c.frequency == "daily"
        # This will return gap in terms of hours
        # store it in a hash
        gap = (24 / c.repetition).hours
        @gap << { c.name.to_s => gap }
      elsif c.frequency == "weekly"
        # This will return a float value in days
        gap = 7.fdiv(c.repetition).days
        @gap << { c.name.to_s => gap }
      elsif c.frequency == "monthly"
        # Need check if is current month distributing or next month,
        # as we may have months of different dates
        # Take reference from days
        # This should return gap in days
        gap = @total_days.fdiv(c.repetition).days if @days_to_eom <= 7
        gap = Date.new(Date.today.year, Date.today.mon, -1).day.days if @days_to_eom > 7
        @gap << { c.name.to_s => gap }
      end
    end
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
