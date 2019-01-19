
# predict if doom is gonna happen today.

require './nasa.rb'
require 'json'

api = Nasa.new
coronal_mass_ejection = api.coronal_mass_ejection
sun_flare = api.solar_flare

unless coronal_mass_ejection.to_s.empty?

	puts "\nNoticed coronal mass ejections recently!\n"

	coronal_mass_ejection = JSON.parse(coronal_mass_ejection.body)

	coronal_mass_ejection.each do |activity|
		activity.each do |key, value|
			if key == 'activityID'
				puts "Found activity: #{value}"
			elsif key == 'note'
				puts value
			elsif key == 'sourceLocation'
				puts "Coming form #{value}"
			end
		end
	end
	
end

unless sun_flare.body.to_s.empty?

	puts "\nNoticed solar flares recently!\n"

	sun_flare = JSON.parse(sun_flare.body) 

	sun_flare.each do |flare|
		flare.each do |key, value|
			if key == 'flrID'
				puts "Detected a flare: #{value}"
			elsif key == 'classType'
				puts "Of type: #{value}"
			elsif key == 'sourceLocation'
				puts "Coming from: #{value}"
			end
		end
	end
				
end

if coronal_mass_ejection.to_s.empty? && sun_flare.body.to_s.empty?
	puts "There is nothing to worry about!"
	puts "Try again later"
end
