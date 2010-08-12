Warbler::Config.new do |config|
  config.dirs = %w(lib views public tmp)
  config.includes = FileList["appengine-web.xml", "app.rb"]
  config.staging_dir = 'war'
  config.java_libs = []
  config.gems = ['sinatra', 'json', 'hpricot', 'appengine-apis']
  config.gem_dependencies = true 
  config.webxml.booter = :rack 
end
