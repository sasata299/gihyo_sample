class HbaseController < ApplicationController
  require 'stargate'

  def sample
    client = Stargate::Client.new("http://localhost:8080")
    
    # テーブルの一覧を返す
    client.list_tables

    # usersテーブルを作成(user, blogは列ファミリ)
    client.create_table('users', 'user', 'blog')

    # usersテーブルにrow_idがA00001のデータを作成する
    client.create_row('users', 'A00001', Time.now.to_i, [{:name => 'blog:title', :value => "(ﾟ∀ﾟ)o彡 sasata299's blog"}, {:name => 'blog:type', :value => 'livedoor'}])

    # usersテーブルのrow_idがA00001のデータを取得する
    # 見つからない場合、例外(Stargate::RowNotFoundError)を返す
    row = client.show_row('users', 'A00001')
    row.columns.each do |_row|
      p _row.name  # "blog:title", "blog:type"
      p _row.value # "(ﾟ∀ﾟ)o彡 sasata299's blog", "livedoor"
    end

    # usersテーブルを削除する
    client.delete_table('users')
    
    render :text => "1"
  end
end
