# coding: utf-8
module Db_gazo
  def connect
    db = YAML.load_file("database.yml")
    
    # データベースに接続
    @gazo_client = Mysql2::Client.new(
      :host => "#{db['gazo']['host']}",
      :username => "#{db['gazo']['username']}",
      :password => "#{db['gazo']['password']}",
      :socket => "#{db['gazo']['socket']}",
      :encoding => "#{db['gazo']['encoding']}",
      :database => "#{db['gazo']['database']}"
    )
    @gazo_table = "#{db['gazo']['table']}"
  end
end
