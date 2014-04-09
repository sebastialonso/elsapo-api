class BusesController < ApplicationController
  respond_to :json

  def index
    @buses = Bus.all
  end

  def show
    @bus = Bus.find(params[:id])
  end

  def predict
    @bus = Bus.find(1)
    respond_to do |format|
      format.json { render json: @bus, success: true, status: :created }
    end
  end
end
