
# some fun with NASA APIs.

require 'net/http'
require 'open-uri'
require 'json'

class Nasa 

	attr_accessor :api_key

	def initialize
		@api_key = 'DkrUJssfe9sm97l5jiomSXPOI79JdDJBSwiCVCJk'
	end

	def apod
		uri = URI("https://api.nasa.gov/planetary/apod?api_key=#{api_key}")
		response = connect('get', uri)
	end

	def connect method, uri
		request = select_method(method, uri)
		response = ''
		Net::HTTP.start(uri.host, uri.port, {:use_ssl => uri.scheme == 'https'}) do |https|
			response = https.request(request)
			puts "The response code: " + response.code
			response_code = response.code
		end
		response
	end

	def select_method method, uri
		request = ''
		case method
			when 'get'
				request = Net::HTTP::Get.new(uri)
			when 'post'
				request = Net::HTTP::Post.new(uri)
		end
		request
	end

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

end

api = Nasa.new()
picture_response = api.apod
api.save_picture picture_response



