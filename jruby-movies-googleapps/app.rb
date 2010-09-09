require 'rubygems'
require 'open-uri'
require 'sinatra'
require 'json'
require 'hpricot'
require 'cgi'
require 'iconv'
require 'appengine-rack'
require 'appengine-apis/urlfetch'

get '/movies' do
	listing = []
	Net::HTTP = AppEngine::URLFetch::HTTP
	flag =1
	i=0
	while flag == 1
		url = "http://www.google.co.in/movies?near="+params[:city]+"&sort=1&start="+(i*10).to_s
		doc = Hpricot(AppEngine::URLFetch::HTTP.get(URI.parse(url)))
		links = doc/"//div[@class=movie]"
		if(!links.empty?)
			links.map.each {|link| 
				header = link/"//div[@class=desc]"
				movie = Hash.new()
				movie["name"] = header.at("a").inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub("&#39;","'")
				movie["name"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', movie["name"]).pop		
				movie["theaters"] = Array.new()
				theaters = link/"//div[@class=theater]"
				theaters.map.each {|theater|
						name = theater/"//div[@class=name]"
						showtimes = theater/"//div[@class=times]"
						theaterHash = Hash.new()
						theaterHash["name"] = theater.at("a").inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub("&#39;","'")
						theaterHash["name"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', theaterHash["name"]).pop
						theaterHash["times"] = showtimes.inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub(/<\/?[^>]*>/, "")
						theaterHash["times"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', theaterHash["times"]).pop
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
	{"listing" => listing.sort}.to_json
end

get '/movielistings' do
	listing = []
	flag =1
	i=0
	while flag == 1
		url = "http://www.google.com/movies?near="+CGI::escape(params[:city])+"&sort=1&start="+(i*10).to_s
		doc = Hpricot(AppEngine::URLFetch::HTTP.get(URI.parse(url)))
		title_bar = doc/"//h1[@id=title_bar]"
		location = title_bar.to_s.gsub(/<\/?[^>]*>/, "");
		location = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', location).pop
		links = doc/"//div[@class=movie]"
		if(!links.empty?)
	
			links.map.each {|link| 
				header = link/"//div[@class=desc]"
				movie = Hash.new()
				movie["name"] = header.at("a").inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub("&#39;","'")
				movie["name"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', movie["name"]).pop
				movie["theaters"] = Array.new()

				theaters = link/"//div[@class=theater]"
				theaters.map.each {|theater|
						name = theater/"//div[@class=name]"
						showtimes = theater/"//div[@class=times]"
						theaterHash = Hash.new()
						theaterHash["name"] = theater.at("a").inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub("&#39;","'")
						theaterHash["name"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', theaterHash["name"]).pop
						theaterHash["times"] = showtimes.inner_html.gsub("&nbsp;","").gsub("&amp;","&").gsub(/<\/?[^>]*>/, "")
						theaterHash["times"] = Iconv.iconv('US-ASCII//IGNORE', 'UTF-8', theaterHash["times"]).pop
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
	temp1 = {"result" => {"listing" => listing.sort, "location" => location}}
	temp1.to_json
end
get '/test' do
	"test"
end

get '/' do
	"hello"
end
