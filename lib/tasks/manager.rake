namespace :manage do
	task :reset => :environment do
		Rake::Task["db:reset"].reenable
		Rake::Task["db:reset"].invoke
	
		Rake::Task["db:migrate"].reenable
		Rake::Task["db:migrate"].invoke
		
		create_source("The Verge", 'http://www.theverge.com/')
		create_source("Tech Crunch", 'http://www.techcrunch.com')
		
		create_user()
		
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
	
	# or just call curl -d "user[email]=test@test.com" -d "user[password]=password" -d "user[password_confirmation]=password" http://serene-ridge-8390.herokuapp.com/users
	def create_user()
		Kernel.system 'curl -d "user[email]=test@test.com" -d "user[password]=password" -d "user[password_confirmation]=password" localhost:3000/users'
		
		Kernel.system 'curl -d "user[email]=test@test.com" -d "user[password]=password" -d "user[password_confirmation]=password" http://serene-ridge-8390.herokuapp.com/users'
	
#		user = User.where("email = ?", email).first
#		if user.nil?
#			user = User.new({email: email, encrypted_password: password})
#			unless user.save
#				puts "user did not save"
#			end
#		end
	end
end