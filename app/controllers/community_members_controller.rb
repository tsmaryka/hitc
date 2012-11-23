class CommunityMembersController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  autocomplete
  
   def index 
    hobo_index CommunityMember.specialscope.apply_scopes(:search => [params[:search], :name, :city, :province], :order_by  => parse_sort_param(:name, :province, :city, :age))
    
  end  

end
