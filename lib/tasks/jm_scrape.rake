namespace :jm_scrape do 
    desc "save new article"
    
    def create_article(options = {})
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

    task :nyt => :environment do 
        # include FileHelpers
        # FileHelpers::save_string_to_file("hello world", "/test.txt")
        create_article({url: "http://www.test.com", title: "title_string", preview: "preview", updated: "updated", author: "author", published: "published", page_content: "page content"})
    end

end