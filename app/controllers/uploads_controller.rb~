class UploadsController < ApplicationController

	def upload 
		if request.post?
			secret_key = request.request_parameters()['subjectCode'].read
			trialData = request.request_parameters()['file'].read
			@result = 'thanks for posting!'
			
			enrollment = StudyEnrollment.find(:first, :conditions => ["secret_key = ?", secret_key])
			if enrollment == nil || enrollment.state == 'completed'
				raise "This study cannot accept your submission. Relaunch your test from the site"
				return
			end
			
			data_point = DataPoint.new
			data_point.study_enrollment = enrollment
			data_point.data = trialData
			data_point.save
			
		else
			@result = 'Upload data from Tatool'
		end
	end
  
end
