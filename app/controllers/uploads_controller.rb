class UploadsController < ApplicationController

	def upload 
		if request.post?
			name = request.request_parameters()['secret_key'].read
			outputFile = request.request_parameters()['outputFile'].read
			@result = name + "\n" + outputFile
		else
			@result = 'Upload data from Tatool'
		end
	end
  
end
