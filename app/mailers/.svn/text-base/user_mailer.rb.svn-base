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

class UserMailer < ActionMailer::Base
  default :from => "no-reply@headsinthecloud.com"

  def forgot_password(user, key)
    @user, @key = user, key
    mail( :subject => "#{app_name} -- forgotten password",
          :to      => user.email_address )
  end


  def activation(user, key)
    @user, @key = user, key
    puts "sending activation email!"
    mail( :subject => "#{app_name} -- activate",
          :to      => user.email_address )
  end
  
  def approved(researcher)
  	@researcher = researcher
  	mail( :subject 	=> "#{app_name} -- Research Account Approved",
  				:to 			=> researcher.user.email_address )
  end
  
  def invited(study_invitation)
  	@study_invitation = study_invitation
  	return mail(:subject => "#{app_name} -- Invite to Study", :to => study_invitation.community_member.user.email_address )
  end

end
