class TokyotyrantTdbController < ApplicationController
  require 'tokyotyrant'
  include TokyoTyrant

  before_filter :set_connection, :do_init
  after_filter :do_finalize

  def set
    @rdb['1'] = {"name" => "山田花子", "sex" => "female", "birthday" => "20050321"}
    @rdb['2'] = {"name" => "鈴木太郎", "sex" => "male", "birthday" => "20060601"}
    @rdb['3'] = {"name" => "佐藤洋子", "sex" => "female", "birthday" => "20070311"}
    @rdb['4'] = {"name" => "山田健一", "sex" => "male", "birthday"=> "20070523"}

    render :text => "1"
  end
  
  def get
    qry = RDBQRY::new(@rdb)
    qry.addcond("name", RDBQRY::QCSTRBW, "山田")
    qry.setorder("birthday", RDBQRY::QONUMDESC)
    res = qry.search()

    p res # ["4", "1"] (keyが返ってくる)
    p @rdb.get(res[0]) # {"name" => "山田健一", "sex" => "male", "birthday"=> "20070523"} 
    p @rdb.get(res[1]) # {"name" => "山田花子", "sex" => "female", "birthday" => "20050321"}

    render :text => "1"
  end

  private 

  def set_connection
    @connection = {
      :master => ['localhost', 1981],
      :slave => [
        ['localhost', 1982],
        ['localhost', 1983]
      ]
    }
  end

  def do_init
    @rdb = RDBTBL::new() # テーブルデータベース

    case action_name
    when 'set'
      _con = @connection[:master]
      @rdb.open(_con[0], _con[1])
      logger.info "write to master: #{_con[0]}:#{_con[1]}"
    when 'get'
      _con = @connection[:slave].sort_by{rand}.first
      @rdb.open(_con[0], _con[1])
      logger.info "read from slave: #{_con[0]}:#{_con[1]}"
    end

    @rdb.setindex("name", RDBTBL::ITLEXICAL) # インデックス
  end

  def do_finalize
    @rdb.close()
  end
end
