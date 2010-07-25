class BenchmarkController < ApplicationController
  require 'benchmark'
  require 'memcache'

  def set
    Benchmark.bm do |x|
      x.report('myisam') {
        1.upto(10000) do |num|
          MyisamArticle.create(
            :title => "title_#{num}",
            :body => "body_#{num}"
          )
        end
      }
      x.report('innodb') {
        1.upto(10000) do |num|
          InnoArticle.create(
            :title => "title_#{num}",
            :body => "body_#{num}"
          )
        end
      }
      x.report('memcached') {
        @memcache = MemCache.new('localhost:11211')
        1.upto(10000) do |num|
          @memcache[num] = {
            :title => "title_#{num}",
            :body => "body_#{num}"
          }
        end
      }
      x.report('TokyoTyrant') {
        @tt = MemCache.new('localhost:1978')
        1.upto(10000) do |num|
          @tt[num] = {
            :title => "title_#{num}",
            :body => "body_#{num}"
          }
        end
      }
    end

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
