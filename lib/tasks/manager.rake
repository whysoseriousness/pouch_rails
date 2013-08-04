namespace :manage do
	task :init => :environment do
		create_source("The Verge", 'http://www.theverge.com/')
		create_source("Tech Crunch", 'http://www.techcrunch.com')
	end
	
	def create_source(name, url)
		@source = Source.new({name: name, url: url})
		unless @source.save
			puts "article did not save"
		end
	end
end