class TestMailer < ActionMailer::Base
  default :from => "no-reply@headsinthecloud.com"

  def send_mail()
    puts "sending test email"
    puts ActionMailer::Base.smtp_settings
    puts ActionMailer::Base.perform_deliveries
    puts ActionMailer::Base.raise_delivery_errors = true
    mail( :subject => "#{app_name} -- forgotten password",
          :to      => "trevormaryka@gmail.com" )
  end

end
