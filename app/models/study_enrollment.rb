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

class StudyEnrollment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
  	secret_key :string, :unique
    timestamps
  end
  
  belongs_to :community_member
  belongs_to :study
  
  def title
  	study.title
  end
  
  def generate_key
  	require 'digest/sha1'
  	x = rand(9999999999999999)
  	key_timestamp = Time.now.utc
  	self.secret_key = Digest::SHA1.hexdigest("#{x}#{key_timestamp}")
  	self.save
  end
  
  lifecycle do

    state :enrolled, :default => true
    state :completed
    
  end

  
  # --- Permissions --- #

  def create_permitted?
    acting_user.user_type == "community" && acting_user.community_details_entered?
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    if acting_user.is_manager?
    	return true
    end
    
    if acting_user.is_researcher?
   		if study_id == nil
   			return true
   		end
   		return acting_user.researcher.owns(self.study)
   	end
    
    if acting_user.is_community_member?
    	return self.community_member.user == acting_user
    end
    
    return false
  end

  def view_permitted?(field)
    self.community_member.user == acting_user || (acting_user.is_researcher? and acting_user.researcher.owns(self.study) ) || acting_user.user_type == "manager"
  end

end
