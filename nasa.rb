
# some fun with NASA APIs.

require 'net/http'
require 'open-uri'
require 'date'

class Nasa 

	attr_accessor :api_key, :host, :protocol

	def initialize
		@api_key = 'DkrUJssfe9sm97l5jiomSXPOI79JdDJBSwiCVCJk'
		@host = 'api.nasa.gov'
		@protocol = 'https'
	end

	def apod
		path = 'planetary/apod'
		param = ["api_key=#{api_key}"]
		uri = construct_uri(path, param)
		puts uri
		response = connect('get', uri)
	end

	def coronal_mass_ejection
		startDate = Date.today - 20
		startDate.strftime "%Y-%m-%d"
		endDate = Date.today + 10
		endDate.strftime "%Y-%m-%d"
		path = 'DONKI/CME'
		params = ["startDate=#{startDate}", "endDate=#{endDate}", "api_key=#{@api_key}"]
		uri = construct_uri(path, params)
		puts uri
		response = connect('get', uri)
	end

	def solar_flare
		startDate = Date.today - 20
		startDate.strftime "%Y-%m-%d"
		endDate = Date.today + 10
		endDate.strftime "%Y-%m-%d"
		path = 'DONKI/FLR'
		params = ["startDate=#{startDate}", "endDate=#{endDate}", "api_key=#{@api_key}"]
		uri = construct_uri(path, params)
		puts uri
		response = connect('get', uri)
	end

	def construct_uri path, params
		uri = "#{@protocol}://#{@host}/#{path}"
		unless params.nil?
			uri = uri + "?"
			params.each do |param|
				uri = uri + "#{param}&"
			end
			uri = uri.chop
		end
		uri = URI(uri)
	end

	def connect method, uri
		request = select_method(method, uri)
		response = ''
		Net::HTTP.start(uri.host, uri.port, {:use_ssl => uri.scheme == 'https'}) do |https|
			response = https.request(request)
			puts "The response code: " + response.code
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

end
