
# welcomes you with NASA's picture of the day

require './nasa.rb'
require 'json'

def save_picture response
	body = JSON.parse(response.body)

	url = ''
	body.each do |key, value|
		if key == 'url'
			url = value
		end
	end
	
	puts "picture url is: #{url}"

	picture_name = /([A-Za-z0-9_\-]*.jpg)$/.match(url)[1]
	
	open(url) {|connection|
	   File.open(picture_name, "wb") do |file|
	     file.puts connection.read
	   end
	}
end

api = Nasa.new()
picture_response = api.apod
save_picture picture_response
