require 'rubygems'
require 'open-uri'
require 'sinatra'
require 'json'
require 'hpricot'

get '/hi' do
	listing = []

	for i in 0..2 do
	url = "http://www.google.co.in/movies?near="+params[:city]+"&sort=1&start="+(i*10).to_s
	doc = Hpricot(open(url))
	links = doc/"//div[@class=movie]"
	links.map.each {|link| 
		header = link/"//div[@class=desc]"
		movie = Hash.new()
		movie["name"] = header.at("a").inner_html
		movie["theaters"] = Array.new()

		theaters = link/"//div[@class=theater]"
		theaters.map.each {|theater|
				name = theater/"//div[@class=name]"
				showtimes = theater/"//div[@class=times]"
				theaterHash = Hash.new()
				theaterHash["name"] = theater.at("a").inner_html
				theaterHash["times"] = showtimes.inner_html.gsub("&nbsp;","")
				movie["theaters"].push(theaterHash)
				}
		listing.push(movie)
		}

	end
	headers({"Content-Type" => "text/html; charset=ISO-8859-1"})
	{"listing" => listing}.to_json
end

get '/test' do
	headers({"Content-Type" => "text/html; charset=ISO-8859-1"})
	erb("hello")
end
