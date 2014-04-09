class BusesController < ApplicationController
  respond_to :json

  def index
    @buses = Bus.all
  end

  def show
    @bus = Bus.find(params[:id])
  end

  def predict
    @bus = Bus.find(params[:bus_id])
  end
end
