#ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.perform_deliveries = true
#ActionMailer::Base.raise_delivery_errors = true
#ActionMailer::Base.smtp_settings = {
#	:user_name => "tsmaryka",
#	:password => "",
#	:domain => "uvic.ca",
#	:address => "mail.uvic.ca",
#	:port => 465,
#	:authentication => :plain,
#	:enable_starttls_auto => true,
#	:openssl_verify_mode => 'none' 
#}
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
	:user_name => "headsinthecloud",
	:password => "h3ad5inth3cl0ud",
	:domain => "uvic.ca",
	:address => "smtp.sendgrid.net",
	:port => 587,
	:authentication => :plain,
	:enable_starttls_auto => true
}
