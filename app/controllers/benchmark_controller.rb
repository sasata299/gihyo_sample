class BenchmarkController < ApplicationController
  require 'benchmark'
  require 'memcache'
  require 'mongo_mapper'
  require 'stargate'

  def set
    Benchmark.bm do |x|
      x.report('MyISAM') {
        1.upto(10000) do |num|
          MyisamArticle.create(
            :title => "title_#{num}",
            :body => "body_#{num}"
          )
        end
      }
      x.report('InnoDB') {
        1.upto(10000) do |num|
          InnodbArticle.create(
            :title => "title_#{num}",
            :body => "body_#{num}"
          )
        end
      }
      x.report('memcached') {
        @memcache = MemCache.new('localhost:11211')

        1.upto(10000) do |num|
          @memcache[num.to_s] = {
            :title => "title_#{num}",
            :body => "body_#{num}"
          }
        end
      }
      x.report('TokyoTyrant') {
        @tt = MemCache.new('localhost:1978')

        1.upto(10000) do |num|
          @tt[num.to_s] = {
            :title => "title_#{num}",
            :body => "body_#{num}"
          }
        end
      }
      x.report('MongoDB') {
        MongoMapper.connection = Mongo::Connection.new("localhost", 27017)
        MongoMapper::database = 'test'

        1.upto(10000) do |num|
          MongoArticle.create(
            :title => "title_#{num}",
            :body => "body_#{num}"
          )
        end
      }
      x.report('HBase') {
        client = Stargate::Client.new("http://localhost:8080")

        client.create_table('articles', 'data')
        1.upto(10000) do |num|
          client.create_row('articles', num.to_s, Time.now.to_i, [
            {:name => 'data:title', :value => "title_#{num}"},
            {:name => 'data:body', :value => "body_#{num}"}
          ])
        end
      }
    end

    render :text => 'finish'
  end

  def get
    Benchmark.bm do |x|
      x.report('MyISAM') {
        1.upto(10000) do |num|
          MyisamArticle.first(:conditions => %Q!title = "title_#{1 + rand(10000)}"!)
        end
      }
      x.report('InnoDB') {
        1.upto(10000) do |num|
          InnodbArticle.first(:conditions => %Q!title = "title_#{1 + rand(10000)}"!)
        end
      }
      x.report('memcached') {
        @memcache = MemCache.new('localhost:11211')

        @memcache[(1 + rand(10000)).to_s]
      }
      x.report('TokyoTyrant') {
        @tt = MemCache.new('localhost:1978')

        @tt[(1 + rand(10000)).to_s]
      }
      x.report('MongoDB') {
        MongoMapper.connection = Mongo::Connection.new("localhost", 27017)
        MongoMapper::database = 'test'

        1.upto(10000) do |num|
          MongoArticle.first(:title => "title_#{1 + rand(10000)}")
        end
      }
      x.report('HBase') {
        client = Stargate::Client.new("http://localhost:8080")

        1.upto(10000) do |num|
          row = client.show_row('articles', (1 + rand(10000)).to_s)
        end
      }

      render :text => 'finish'
    end
  end
end
