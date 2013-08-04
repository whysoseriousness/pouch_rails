namespace :manage do
	task :init_db => :environment do
		create_source("The Verge", 'http://www.theverge.com/rss/frontpage')
		create_source("Tech Crunch", 'http://feeds.feedburner.com/TechCrunch/')
	end
	
	def create_source(s_name, s_url)
		@source = Source.new({name: name, url: url})
		unless @source.save
			puts "article did not save"
		end
	end
end