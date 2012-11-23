class StudyEnrollmentsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def launch	
  	@enrollment = StudyEnrollment.find(params[:id])
  	respond_to do |format|
  		format.jnlp
  	end
  end
  

end
