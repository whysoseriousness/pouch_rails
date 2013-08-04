namespace :manage do
	task :init => :environment do
		Rake::Task["db:migrate"].reenable
		Rake::Task["db:migrate"].invoke
		
		create_source("The Verge", 'http://www.theverge.com/')
		create_source("Tech Crunch", 'http://www.techcrunch.com')
	end
	
	task :cleardb => :environment do
		Rake::Task["db:reset"].reenable
		Rake::Task["db:reset"].invoke
	end
	
	def create_source(name, url)
		source = Source.where("url = ?", url).first
		if source.nil?
			@source = Source.new({name: name, url: url})
			unless @source.save
				puts "article did not save"
			end
		end
	end
end