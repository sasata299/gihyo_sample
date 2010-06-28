class MongodbController < ApplicationController
  require 'mongo_mapper'
  MongoMapper.connection = Mongo::Connection.new("localhost", 27017, :logger => Logger.new(STDOUT))
  MongoMapper::database = 'test'

  def set
    User.create(:name => "太郎1")
    User.create(:name => "太郎2", :age => 20)
    User.create(:name => "太郎3", :interest => %w!soccer baseball tennis!)
    User.create(:name => "太郎4", :interest => %w!soccer!)

    render :text => "1"
  end

  def get
    p User.all(:name => "太郎1")                           # 太郎1
    p User.all(:age => 20)                                 # 太郎2

    # interestにsoccerを含んでいるデータ
    p User.all(:interest => "soccer")                      # 太郎3, 太郎4

    # nterestにsoccerもしくはtennisを含んでいるデータ
    p User.all(:interest => %w!soccer tennis!)             # 太郎3, 太郎4

    # interestにsoccerとtennisを両方とも含んでいるデータ
    p User.all(:interest => {"$all" => %w!soccer tennis!}) # 太郎4

    render :text => "1"
  end

  def add_to_set
    p User.first(:name => "太郎4") # interest: ["soccer"]

    User.add_to_set({:name => "太郎4"}, :interest => "tennis")
    p User.first(:name => "太郎4") # interest: ["soccer", "tennis"]

    User.add_to_set({:name => "太郎4"}, :interest => "soccer")
    p User.first(:name => "太郎4") # interest: ["soccer", "tennis"]

    render :text => "1"
  end
end
