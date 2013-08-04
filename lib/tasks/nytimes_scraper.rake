namespace :scrape do
	task :verge_list => :environment do
		require 'rubygems'
		require 'nokogiri'
		require 'open-uri'
		require 'htmlentities'
		
		url = "http://www.theverge.com/rss/frontpage"
		doc = Nokogiri::HTML(open(url))
		doc.css("entry").each do |item|
			title = item.at_css("title").text
			published = item.at_css("published").text
			updated = item.at_css("updated").text
			author = item.at_css("author").text
			
			# Logic to get preview
			# decode content so we can use Nokogiri
			preview_raw = HTMLEntities.new.decode item.at_css("content")
			# get text inside first paragraph
			preview_raw = Nokogiri::HTML(preview_raw).at_css("content").at_css("p").text
			num_words = 10
			# get first <num_words> words
			preview = preview_raw.split(/\s+/, num_words+1)[0...num_words].join(' ') + '...'
			
			# Logic to get page_content
			page_url = item.at_css("id").text
			page_doc = Nokogiri::HTML(open(page_url))
			page_content = pretty_strip(page_doc.at_css(".article-body")) #Before: .entry-content
			
			#puts "#{title} - #{published} (last updated #{updated})"
			#puts "By #{author}"
			#puts preview
			#puts page_url
			#puts page_content
			
			options = {url: page_url,
							title: title,
							published: published,
							updated: updated,
							author: author,
							preview: preview,
							page_content: page_content}
			 #{url, file_path, title, preview, updated, author}
			 
			page_content = options.delete(:page_content)

			@article = Article.new(options)
		   
			if @article.save #{}"/public/assets/articles/filesavingtest.txt"
				file_name = "article#{@article.id}.html"
				file_path = Rails.root.join('public', 'assets', 'articles', file_name)
				@article.file_path = file_path
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
	
	# remove white space between lines
	def pretty_strip(html) 
		html.search('//text()').each do |t| 
			t.replace(t.content.strip)
		end
		return html
	end
	
	def create_article(options = {})
       
    end
end