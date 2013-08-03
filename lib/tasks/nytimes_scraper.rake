

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
			
			preview = HTMLEntities.new.decode item.at_css("content")
			
			#preview = item.at_css("content")#.at_css("p")#.text.split(/\s+/, n+1)[0...n].join(' ')
			
			page_url = item.at_css("id").text
			page_doc = Nokogiri::HTML(open(page_url))
			
			#Before: .entry-content
			page_content = pretty_strip(page_doc.at_css(".article-body"))
			
			puts "#{title} - #{published} (last updated #{updated}"
			puts "By #{author}"
			puts preview
			puts page_url
			#puts page_content
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