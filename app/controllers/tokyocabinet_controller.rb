class TokyocabinetController < ApplicationController
  require 'json'
  require 'tokyocabinet'
  include TokyoCabinet

  before_filter :do_init
  after_filter :do_finalize

  def set
    @hdb['key1'] = 100
    @hdb['key2'] = ["foo", "bar"].to_json
    @hdb['key3'] = {"a" => "ほげ", "b" => "ふが"}.to_json

    render :text => "1"
  end

  def get
    p @hdb['key1']             # "100"
    p JSON.parse(@hdb['key2']) # ["foo", "bar"]
    p JSON.parse(@hdb['key3']) # {"a" => "ほげ", "b" => "ふが"}

    render :text => "1"
  end

  private

  def do_init
    @hdb = HDB.new # ハッシュデータベースを指定
    @hdb.open('hoge.tch', HDB::OWRITER | HDB::OCREAT)
  end

  def do_finalize
    @hdb.close
  end
end
