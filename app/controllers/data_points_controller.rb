class DataPointsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def data	
  	@data_point = DataPoint.find(params[:id])
  	respond_to do |format|
  		format.csv
  	end
  end

end
