class SapeadasController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json

  def index
    @sapeadas = Sapeada.all  
  end

  def create
    respond_to do |format|
      format.json {
        puts "INCOMIIIIIIIIIIIIIIIIING"
        @sapeada = Sapeada.new sapeada_params
        @sapeada.catch_time = date_to_seconds sapeada_params[:catch_time]
        if @sapeada.save
          render json: @sapeada, success: true, status: :created
        else
          render json: resources.errors, status: :unprocessable_entity
        end
      }
    end
  end

  private
    def sapeada_params
      params.require(:sapeada).permit(:bus_id, :latitude, :longitude, :week_day, :catch_time)
    end

    def date_to_seconds(date)
      date = date.to_datetime.in_time_zone
      return date.hour*60*60 + date.min*60 + date.sec
    end
end
