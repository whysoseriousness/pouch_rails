namespace :scrape do
	task :all => :environment do
		require 'rubygems'
		require 'nokogiri'
		require 'open-uri'
		require 'htmlentities'
		
		verge()
		techcrunch()
	end

	task :verge_list => :environment do
		verge()
	end
	
	def verge()
		
		url = 'http://www.theverge.com/rss/frontpage'
		doc = Nokogiri::HTML(open(url))
		
		source_url = 'http://www.theverge.com/'
		#puts "Source URL: #{source_url}"
		
		doc.css("entry").each do |item|
			title = item.at_css("title").text
			published = item.at_css("published").text
			updated = item.at_css("updated").text
			author = item.at_css("author").text
			
			# Logic to get preview
			# decode content so we can use Nokogiri
			preview_raw = HTMLEntities.new.decode item.at_css("content")
			preview = get_preview(Nokogiri::HTML(preview_raw))
			
			# Logic to get page_content
			page_url = item.at_css("id").text
			page_doc = Nokogiri::HTML(open(page_url))
			page_content = pretty_strip(page_doc.at_css(".article-body")) 
			
			#puts "Title: #{title}"
			#puts "Published: #{published} (last updated #{updated})"
			#puts "Author: #{author}"
			#puts "Url: #{page_url}"
			#puts preview
			
			create_article({url: page_url,
							title: title,
							published: published,
							updated: updated,
							author: author,
							preview: preview,
							source_url: source_url,
							page_content: page_content})
		end
	end
	
	#def load_techcrunch_articles()
	task :techcrunch_list => :environment do
		techcrunch()
	end
		
	def techcrunch()
		url = 'http://feeds.feedburner.com/TechCrunch/'
		doc = Nokogiri::HTML(open(url))
		
		#source_url = doc.at_css('channel link').text
		#puts "Source Url: #{source_url}"
		
		source_url = 'http://www.techcrunch.com'
		#puts "Source URL: #{source_url}"
		
		doc.css('item').each do |item|
			title = item.at_css("title").text
			published = item.at_css("pubdate").text
			updated = item.at_css("pubdate").text # no updated field
			author = item.at_css("creator").text
			page_url = item.at_css("origlink").text
			
			# Logic to get page_content
			page_content = item.at_css("encoded")
			
			preview = get_preview(page_content)
			
			#puts "Title: #{title}"
			#puts "Published: #{published} (last updated #{updated})"
			#puts "Author: #{author}"
			#puts "Url: #{page_url}"
			#puts preview
			
			create_article({url: page_url,
							title: title,
							published: published,
							updated: updated,
							author: author,
							preview: preview,
							source_url: source_url,
							page_content: page_content})
		end
	end
	
	# remove white space between lines
	def pretty_strip(html) 
		html.search('//text()').each do |t| 
			t.replace(t.content.strip)
		end
		return html
	end
	
	# get first <num_words> read words of an html file
	# first set of text must appear at <p>
	def get_preview(html)
		num_words = 10
		all_text = html.at_css("p").text
		return all_text.split(/\s+/, num_words+1)[0...num_words].join(' ') + '...'
	end
	
	def create_article(options = {})
		#{url, file_path, title, preview, updated, author}
        page_content = options.delete(:page_content)

        source_url = options.delete(:source_url)
		
        # TODO: first or create
		art = Article.where("url = ?", options[:url]).first
		if art.nil?
			@source = Source.where("url = ?", source_url).first
			@article = @source.articles.new(options)
		   
			if @article.save #{}"/public/assets/articles/filesavingtest.txt"
				file_name = "article#{@article.id}.html"
				file_path = Rails.root.join('public', 'assets', 'articles', file_name)
				@article.file_path = file_name
				if @article.save
					File.open(file_path, "w") { |file| file.write page_content }
				else
					puts "article did not save"
				end
			else
				puts "article did not save"
			end
		end
    end
end