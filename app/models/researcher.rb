=begin
Copyright 2012 Trevor Maryka

This file is part of Heads in the Cloud.

    Heads in the Cloud is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Heads in the Cloud is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Heads in the Cloud.  If not, see <http://www.gnu.org/licenses/>.
    
=end

class Researcher < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
  	name						 :string, :required
  	street_address   :string, :required
    city             :string, :required
    province         :string, :required
    postal_code      :string, :required
    phone            :string, :required
    primary_language enum_string(:english, :french, :spanish), :default => :english, :required => true
    date_of_birth    :date, :required
    #is_approved			 :boolean
    timestamps
  end

	belongs_to :user, :class_name => "User", :foreign_key => :user_id
	
	after_create do
   self.user = acting_user
   self.save
  end
	
	lifecycle do

    state :not_approved, :default => true
    state :approved
	
		transition :approve, { :not_approved => :approved }, :available_to => "User" do
			UserMailer.approved(self).deliver
		end
  
  end
  
  def is_approved
  	return self.state == 'approved'
  end
  
  def owns(study)
  	if study == nil
  		return false
  	end
  	ownership = StudyOwnership.find(:first, :conditions => ["researcher_id = ? AND study_id = ?", self.id, study.id])
  	return ownership != nil
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.user_type == 'researcher'
  end

  def update_permitted?
  	
  	if acting_user.user_type == 'researcher' && !acting_user.is_researcher? && only_changed?(:user_id) && self.user == acting_user
  		return true
  	end
    if only_changed?(:name, :street_address, :city, :province, :postal_code, :phone, :primary_language, :date_of_birth)
    	return true
    end
    
    if acting_user.signed_up? && acting_user.is_manager?
    	return true
    end
    
    return true
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.signed_up?
  end

end
