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

class TestModule < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    module_identifier   :integer, :required => true
    name 						:string, 	:required => true
    timestamps
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.is_manager?
  end

  def update_permitted?
    acting_user.is_manager?
  end

  def destroy_permitted?
    acting_user.is_manager?
  end

  def view_permitted?(field)
    true
  end

end
