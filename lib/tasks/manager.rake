namespace :manage do
	task :reset => :environment do
		Rake::Task["db:reset"].reenable
		Rake::Task["db:reset"].invoke
	
		Rake::Task["db:migrate"].reenable
		Rake::Task["db:migrate"].invoke
		
		create_source("The Verge", 'http://www.theverge.com/')
		create_source("Tech Crunch", 'http://www.techcrunch.com')
		
		create_user("test@test.com", "password")
		
		Rake::Task["scrape:all"].reenable
		Rake::Task["scrape:all"].invoke
	end
	
	task :cleardb => :environment do
		Rake::Task["db:reset"].reenable
		Rake::Task["db:reset"].invoke
	end
	
	def create_source(name, url)
		source = Source.where("url = ?", url).first
		if source.nil?
			source = Source.new({name: name, url: url})
			unless source.save
				puts "source did not save"
			end
		end
	end
	
	def create_user(email, password)
		user = User.where("email = ?", email).first
		if user.nil?
			user = User.new({email: email, encrypted_password: password})
			unless user.save
				puts "user did not save"
			end
		end
	end
end