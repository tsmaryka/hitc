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
