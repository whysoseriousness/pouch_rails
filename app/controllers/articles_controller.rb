class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    if(params[:user])
      @user = User.where("email=?", params[:user][:email]).first
      @subscriptions = @user.subscriptions
      @articles = []
      # time = params[:time]
      #TODO: parse datetime
      @subscriptions.each do |s|
        @articles.push({name: s.source.name, feed: s.source.articles})
      end
    else
      @articles = Article.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: [{name: "all", feed: @articles }] }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
end

private
  def parse_datetime(str)
    year = str.match(/^[0-9]*/).to_s
    month = str.match(/-[0-9]{2}-/).to_s.gsub("-","").to_s
    day = str.match(/-[0-9]{2}\|/).to_s.gsub("-","").gsub("|","").to_s

    hour = str.match(/\|[0-9]{2}:/).to_s.gsub(":","").gsub("|","").to_s
    minute = str.match(/:[0-9]{2}:/).to_s.gsub(":","").to_s
    second = str.match(/:[0-9]{2}\|/).to_s.gsub(":","").gsub("|","").to_s

    offset = str.match(/\|[0-9]{0,2}\z/).to_s.gsub("|","").to_s

    d = Time.new(year, month, day, hour, minute)
  end