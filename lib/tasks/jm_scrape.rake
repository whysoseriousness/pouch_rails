namespace :jm_scrape do 
    desc "save new article"
    
    def create_article(options = {})
        #{url, file_path, title, preview, updated, author}
        @article = Article.new(options)
        if @article.save
            file_name = "article#{@article.id}.html"
            file_path = Rails.root.join('public', 'assets', 'articles', file_name)#{}"/public/assets/articles/filesavingtest.txt"
            str = "Hello World!"
            File.open(file_path, "w") { |file| file.write options[:page_content] }
            puts str
        else
            puts "article did not save"
        end

    end

    task :nyt => :environment do 
        # include FileHelpers
        # FileHelpers::save_string_to_file("hello world", "/test.txt")
        
    end

end