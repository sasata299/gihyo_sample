class MemcachedController < ApplicationController
  require 'memcache'
  before_filter :do_init

  DEFAULT_EXPIRE = 3600

  def set
    @cache['key1'] = 123                      # 数値
    @cache['key2'] = "あいうえお"             # 文字列
    @cache['key3'] = %w(hoge fuga)            # 配列
    @cache['key4'] = {:foo => 1, :bar => 'a'} # ハッシュ
  end

  def get
    p @cache['key1'] # 123
    p @cache['key2'] # "あいうえお"
    p @cache['key3'] # ["hoge", "fuga"]
    p @cache['key4'] # {:bar=>"a", :foo=>1}
  end

  def show
    if @user = @cache["user#{params[:id]}"]
    unless @user
      @user = User.find(params[:id])
      @cache.set("user#{params[:id]}", @user, DEFAULT_EXPIRE) # 第3引数にexpiresを指定
    end

    # do something
  end

  private

  def do_init
    @cache = MemCache.new(
      ['localhost:11211', 'localhost:11212', 'localhost:11213'], 
      :logger => Logger.new(STDOUT)
    )
  end
end
