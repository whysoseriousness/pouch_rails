

namespace :scrape do
	task :verge_list do
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
			
			puts "#{title} - #{published} (last updated #{updated})"
			puts "By #{author}"
			puts preview
			puts page_url
			#puts page_content
			
			create_article({url: page_url,
							title: title,
							published: published,
							updated: updated,
							author: author,
							preview: preview,
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
	
	task :verge_page do
		require 'rubygems'
		require 'nokogiri'
		require 'open-uri'
		
		page_url = "http://www.theverge.com/2013/8/3/4585700/president-obama-vetoes-samsung-patent-ban-on-iphone-4-and-select-ipads"
		
		page_doc = Nokogiri::HTML(open(page_url))
		page_content = page_doc.at_css(".entry-content")
		page_content.search('//text()').each do |t|
			t.replace(t.content.strip)
		end
		
		File.open('C:\Users\Gateway\Desktop\verge_page_output.html', 'w') { |file| file.write(page_content) }
	end
end