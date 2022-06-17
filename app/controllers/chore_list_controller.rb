class ChoreListController < ApplicationController


  def index
    if params[:assign_chores].present?
      demonalgo
    end
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
      d = params.require(:chore_list).permit(:deadline)
      @task = ChoreList.find(params[:id])
      @task.update(d)
      redirect_to chore_list_index_path

      # respond_to do |format|
      #   format.text { render partial: "chore_list/edit_deadline", locals: { task: @task }, formats: [:html] }
      #   format.json
      # end
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
          @completed << arr[i].chore_lists.first.chore
          i += 1
        elsif arr[i].chore_lists.first.deadline < DateTime.now
          @incomplete << arr[i].chore_lists.first
          i += 1
        elsif arr[i].chore_lists.first.deadline > DateTime.now
          @to_do << arr[i].chore_lists.first
          i += 1
          # If nested while doesn't work, use until
          while i < arr.length
            @upcoming << arr[i].chore_lists.first.chore
            i += 1
          end
        end
      end
    end
    @upcoming = @upcoming.group_by(&:name)
    @completed = @completed.group_by(&:name)
  end

  def demonalgo
    y = Date.today.year
    m = Date.today.mon
    d = Date.today.day
    get_days(y, m, d)
    total_flats_chores(y, m)
    assign_chores
  end

  def get_days(y, m, d)
    # this should return us days remaining to end of month
    # check if is created < 7 to end of month
    # total_days && days_to_eom returns an integer
    # @total_days = integer
    @days_to_eom = Date.new(y , m, -1).day - DateTime.now.day
    if @days_to_eom <= 7
      # get next month days
      @total_days = Date.new(y, m + 1, -1).day if m < 12
      @total_days = Date.new(y + 1, 1, -1).day if m == 12
    else
      # get this month remaining days
      @total_days = Date.new(y, m, -1).day - DateTime.now.day
    end
  end

  def total_flats_chores(y, m)
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
    @chore_lists_to_assign = []
    total_chores.each do |c|
      # Create an array to store the lists of chores
      # Use total days / gap to get number of instance to create
      gap = @gap.find { |g| g[c.name] }
      # num = number of instances to create
      num = @total_days.days.fdiv(gap.values[0]).round
      # d = start_date

      @last_chore = current_user.flat_users.find_by(active: true).flat.chores.find_by(name: c.name).chore_lists.last
      if @last_chore.present?
        # This gives date of last chore
        deadline = @last_chore.deadline
      else
        # this gives date of new chore, but we minus gap so the algo can apply the += gap
        deadline = DateTime.new(y, m + 1, 1) - gap.values[0] if m < 12
        deadline = DateTime.new(y + 1, 1, 1) - gap.values[0] if m == 12
      end
      # This will give us a new start_date, assuming changes will only be implemented next month
      for d in 1..num do
        # Create and assign chore, deadline, month, except for user
        @chore_lists_to_assign << ChoreList.new(deadline: deadline += (gap.values[0] - 1.seconds), chore: c, month_list: MonthList.create(month:Date.today.next_month))
        # ChoreList.new(deadline: DateTime.now + 2.days, chore: Chore.first, month_list: MonthList.create(month: Date.today.next_month))
        # raise
      end
    end
    # End of this method, I should get an array of total chore_lists
    # @chore_lists_to_assign = [cl_instance, cl_instance, cl_instance]
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

  def assign_chores
    # From the array of hashes of chore_lists from total_flat chores, iterate through the algo
    # Has a preference converter method, for the above keys(chores), get user preference and add in like gap [done]
    # Has chore_today? [done]
    users = current_user.flat_users.find_by(active: true).flat.users
    # Remember to add the above code when running the algo in case the user got no chores today.
    # Total count of completed chores last month (from chore_listing methods), + this month chore_lists count, this is also CHORE TYPE SPECIFIC [done]
    # Repeat the above for user specific, follow by flat, and div, rounded to 0.01 (up)
    # Rpeat the above 2 lines for total hours
    @chore_lists_to_assign.each do |c|
      @th = total_chores_hours(c.chore.name)
      @th = 1 if total_chores_hours(c.chore.name).zero?
      @tcc = total_chores_count(c.chore.name)
      @tcc = 1 if total_chores_count(c.chore.name).zero?
      @user_to_assign = {}
      users.each do |u|
        if @last_chore.present?
          v = 1.to_f + calc_user_preferences(u, c.chore.name) - chores_today(u, c.chore.name).to_f - user_chores_count(u, c.chore.name).fdiv(@tcc).round(2) - user_chores_hours(u, c.chore.name).fdiv(@th).round(2)
          @user_to_assign.store(v.to_f, u)
        else
          @user_to_assign
        end
      end
      k = @user_to_assign.keys.sort.reverse.first
      u = @user_to_assign[k]
      c.user = u
      c.user = users.sample if @user_to_assign.blank?
      c.save
    end
  end



  def calc_user_preferences(select_user, chore_name_query)
    flat_user_pref = select_user.flat_users.find_by(active: true).flat.chores.find_by(name: chore_name_query).preferences.find_by(user: select_user)
      r = 0.15 if flat_user_pref.rating == 3
      r = 0 if flat_user_pref.rating == 2
      r = -0.15 if flat_user_pref.rating == 1
    return r
  end

  def chores_today(select_user, chore_name_query)
    # Might need to relook this
    cl = select_user.flat_users.find_by(active: true).flat.chores.find_by(name: chore_name_query).chore_lists.where(user: select_user)
    v = 0
    if @last_chore.present? && @last_chore.complete
    cl.each do |c|
      return v = 0.3 if c.deadline.day == Date.today.day
    end
    end
    v
  end

  def total_chores_count(chore_name_query)
    arr = []
    cl = current_user.flat_users.find_by(active: true).flat.chores.find_by(name: chore_name_query).chore_lists
    cl.each do |c|
      # if @last_chore.present? && @last_chore.complete
        arr << c if c.deadline.mon == Date.today.mon
        arr << c if c.deadline.mon == Date.today.mon - 1
      # else
      #   arr << c if c.deadline.mon == Date.today.mon
      #   arr << c if c.deadline.mon == Date.today.mon + 1
      # end
    end
    arr.count
  end

  def user_chores_count(select_user, chore_name_query)
    arr = []
    cl = select_user.flat_users.find_by(active: true).flat.chores.find_by(name: chore_name_query).chore_lists.where(user: select_user)
    cl.each do |c|
      # if @last_chore.present? && @last_chore.complete
        arr << c if c.deadline.mon == Date.today.mon
        arr << c if c.deadline.mon == Date.today.mon - 1
      # else
      #   arr << c if c.deadline.mon == Date.today.mon
      #   arr << c if c.deadline.mon == Date.today.mon + 1
      # end
    end
    arr.count
  end

  def total_chores_hours(chore_name_query)
    # Duration is an integer
    sum = 0
    cl = current_user.flat_users.find_by(active: true).flat.chores.find_by(name: chore_name_query).chore_lists.where(complete: true)
    cl.each do |c|
      sum += c.chore.duration
    end
    sum
  end

  def user_chores_hours(select_user, chore_name_query)
    sum = 0
    cl = select_user.flat_users.find_by(active: true).flat.chores.find_by(name: chore_name_query).chore_lists.where(user: select_user).where(complete: true)
    cl.each do |c|
      sum += c.chore.duration
    end
    sum
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
