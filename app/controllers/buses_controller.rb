class BusesController < ApplicationController
  
  def index
    @buses = Bus.all
    respond_to do |format|
      format.json
    end
  end

  def show

  end
end
