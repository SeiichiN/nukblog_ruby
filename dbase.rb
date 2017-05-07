#!/usr/bin/ruby
#-*-  coding: utf-8 -*-
require 'mysql2'
require 'yaml'

# このクラスは、blog.rb と gazo.rb で読み込まれる。
# このクラスを親として、BlogManagerクラスと
# GazoManagerクラスが作られている。
class BaseDb
  def initialize
    db = YAML.load_file("database.yml")
    
    # データベースに接続
    @client = Mysql2::Client.new(
      :host => "#{db['db']['host']}",
      :username => "#{db['db']['username']}",
      :password => "#{db['db']['password']}",
      :socket => "#{db['db']['socket']}",
      :encoding => "#{db['db']['encoding']}",
      :database => "#{db['db']['database']}"
    )
    @table_name = "#{db['blog']['table']}"
    @gazo_table = "#{db['gazo']['table']}"
  end

  attr_accessor :client, :table_name, :gazo_table
end
