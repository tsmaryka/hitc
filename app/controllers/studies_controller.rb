class StudiesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  auto_actions_for :consent_texts, [:new, :create]

end
