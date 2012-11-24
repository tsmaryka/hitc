class UploadsController < ApplicationController

	def upload 
		if request.post?
			name = request.request_parameters()['subjectCode'].read
			outputFile = request.request_parameters()['file'].read
			@result = name + "\n" + outputFile
			print "start of post\n"
			print name + "\n"
			print outputFile
		else
			@result = 'Upload data from Tatool'
		end
	end
  
end
