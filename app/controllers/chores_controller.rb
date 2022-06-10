class ChoresController < ApplicationController

  def index
  end

  def new
  end

  def create
  end

  def setup
    @flat = Flat.find(params[:id])
    @chores = @flat.chores
    @chore = Chore.new
  end
end
