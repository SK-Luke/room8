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
  end

  def update
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
      # ----------for count <3 ---------------------------
      # Check if first item is incomplete and overdue
      # If yes, check, overdue = incomplete, not overdue and incomplete = todo, else completed
      # if No, check complete, if not complete, todo, and next go to upcoming. If complete, next go to do
      if arr.length < 3
        step_one = arr[i].chore_lists.first.deadline < DateTime.now && arr[i].chore_lists.first.complete
        step_two = arr[i + 1].chore_lists.first.deadline < DateTime.now && arr[i + 1].chore_lists.first.complete
        step_three = arr[i+1].chore_lists.first.deadline > DateTime.now && arr[i+1].chore_lists.first.complete == false

        # Consider if it is in to do first
        if arr[i].chore_lists.first.deadline > DateTime.now && arr[i].chore_lists.first.complete == false
          @to_do << arr[i].chore_lists.first
          @upcoming << arr[i + 1].chore_lists.first
        end
        # consider both as expired deadline first
        if step_one
          @completed << arr[i].chore_lists.first
          if step_two
            @completed << arr[i+1].chore_lists.first
          elsif step_three
            @to_do << arr[i+1].chore_lists.first
          else
            @incomplete << arr[i+1].chore_lists.first
          end
        else
          @incomplete << arr[i].chore_lists.first
          if step_two
            @completed << arr[i+1].chore_lists.first
          elsif step_three
            @to_do << arr[i+1].chore_lists.first
          else
            @incomplete << arr[i+1].chore_lists.first
          end
        end
      end
      # Distribute in order from date time, then check for incomplete
      # ----------for count >=3 ---------------------------
      # If not beyond deadline, check completion status of i + 2
      # If i + 2 exist and is completed, push to completed while i + 1 to todo
      if arr.length >= 3
      end
    end
  end
end
