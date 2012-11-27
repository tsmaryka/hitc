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
			
			enrollment.secret_key = nil
			enrollment.state = 'completed'
			enrollment.save
			
		else
			@result = 'Upload data from Tatool'
		end
	end
  
end
