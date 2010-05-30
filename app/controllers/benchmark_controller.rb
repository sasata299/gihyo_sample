class BenchmarkController < ApplicationController
  def insert
    articles = []
    (1..1000000).each do |num|
      articles << {
        :title => "title_#{num}",
        :body => "body_#{num}",
      }

      if articles.size > 1000
        Article.create!(articles)
        articles = []
      end
    end

    Article.create!(articles) unless articles.blank?

    render :text => 'finish'
  end

  def select
    cache = MemCache.new('localhost:11211')

    @article_body = cache[params[:id]]
    unless cache[params[:id]]
      @article_body = Article.first(:conditions => ['title => ?', "title_#{params[:id]}"]).body
      cache.set(params[:id], @article_body, 120)
    end
  end
end
