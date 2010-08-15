require 'rubygems'
require 'open-uri'
require 'sinatra'
require 'json'
require 'hpricot'
require 'cgi'

get '/tarunrs/movies' do
	listing = []

	for i in 0..2 do
	url = "http://www.google.com/movies?near="+CGI::escape(params[:city])+"&sort=1&start="+(i*10).to_s
	doc = Hpricot(open(url))
	title_bar = doc/"//h1[@id=title_bar]"
	location = title_bar.to_s.gsub(/<\/?[^>]*>/, "");
	links = doc/"//div[@class=movie]"
	links.map.each {|link| 
		header = link/"//div[@class=desc]"
		movie = Hash.new()
		movie["name"] = header.at("a").inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub("&#39;","'")
		movie["theaters"] = Array.new()

		theaters = link/"//div[@class=theater]"
		theaters.map.each {|theater|
				name = theater/"//div[@class=name]"
				showtimes = theater/"//div[@class=times]"
				theaterHash = Hash.new()
				theaterHash["name"] = theater.at("a").inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub("&#39;","'")
				theaterHash["times"] = showtimes.inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub(/<\/?[^>]*>/, "")
				movie["theaters"].push(theaterHash)
				}
		listing.push(movie)
		}

	end
	headers({"Content-Type" => "text/html; charset=ISO-8859-1"})
	{"result" => {"listing" => listing, "location" => location}}.to_json
end

get '/test' do
	headers({"Content-Type" => "text/html; charset=ISO-8859-1"})
	erb("hello")
end
