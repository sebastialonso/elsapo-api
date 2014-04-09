class BusesController < ApplicationController
  respond_to :json

  def index
    @buses = Bus.all
  end

  def show
    @bus = Bus.find(params[:id])
  end
end
