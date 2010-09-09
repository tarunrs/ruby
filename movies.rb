require 'rubygems'
require 'open-uri'
require 'sinatra'
require 'json'
require 'hpricot'
require 'cgi'
require 'iconv'

get '/tarunrs/movies' do
	listing = []
	flag =1
	i=0
	while flag == 1
		url = "http://www.google.com/movies?near="+CGI::escape(params[:city])+"&sort=1&start="+(i*10).to_s
		doc = Hpricot(open(url))
		title_bar = doc/"//h1[@id=title_bar]"

		location = title_bar.to_s.gsub(/<\/?[^>]*>/, "");
		location = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', location).pop
		links = doc/"//div[@class=movie]"
		if(!links.empty?)
	
			links.map.each {|link| 
				header = link/"//div[@class=desc]"
				movie = Hash.new()
				movie["name"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', header.at("a").inner_html).pop.gsub("&nbsp;","").gsub("&amp;","&").gsub("&#39;","'")
				movie["rating"] = header.at("img")
				if(movie["rating"]!= nil)
					regex = Regexp.new(/.*Rated (.*) out of.*/)
					sub_string = regex.match( movie["rating"].to_s)
					 movie["rating"] = sub_string[1]
				end
				movie["theaters"] = Array.new()

				theaters = link/"//div[@class=theater]"
				theaters.map.each {|theater|
						name = theater/"//div[@class=name]"
						showtimes = theater/"//div[@class=times]"
						theaterHash = Hash.new()
						theaterHash["name"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8',theater.at("a").inner_html).pop.gsub("&nbsp;","").gsub("&amp;","&").gsub("&#39;","'")
						theaterHash["times"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', showtimes.inner_html).pop.gsub("&nbsp;","").gsub("&amp;","&").gsub(/<\/?[^>]*>/, "")
						movie["theaters"].push(theaterHash)
						}
				listing.push(movie)
				}
			i=i+1
		else
			flag =0
		end
	end
	headers({"Content-Type" => "text/html; charset=ISO-8859-1"})
	{"result" => {"listing" => listing, "location" => location}}.to_json

end

get '/test' do
	headers({"Content-Type" => "text/html; charset=ISO-8859-1"})
	erb("hello")
end
