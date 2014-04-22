class BusesController < ApplicationController
  respond_to :json

  def index
    @buses = Bus.where(:bus_id => params[:bus_id])
  end

  def predict
    @bus = Bus.find(params[:bus_id])
  end
end
