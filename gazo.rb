#!/usr/bin/perl
# -*- coding: utf-8 -*-
require 'date'
require 'mysql2'
require 'erb'
require './hikidoc'
require 'base64'
require 'yaml'

# 画像1件ぶんのクラスをつくる
class Gazo
  # インスタンス初期化
  def initialize(id, file, comment, ctype, image, created_at, updated_at)
    @id = id
    @file = file
    @comment = comment
    @ctype = ctype
    @image = image
    @created_at = created_at
    @updated_at = updated_at
  end

  # 属性に対するアクセサ
  attr_accessor :id, :file, :comment, :ctype, :image, :created_at, :updated_at
end


class GazoManager
  def initialize
    db = YAML.load_file("database.yml")
    
    # データベースに接続
    @gazo_client = Mysql2::Client.new(
      :host => "#{db['db']['host']}",
      :username => "#{db['db']['username']}",
      :password => "#{db['db']['password']}",
      :socket => "#{db['db']['socket']}",
      :encoding => "#{db['db']['encoding']}",
      :database => "#{db['db']['database']}"
    )
    @gazo_table = "#{db['gazo']['table']}"
  end

  attr_accessor :gazo_client, :gazo_table

  def render_view(template)
    rhtml = ERB.new(File.read("view/#{template}.html.erb"))
    rhtml.result(binding)
  end
  
  def write_html(name, template = 'layout')
    @content = render_view(name)
    print render_view(template)
  end
  
  def listAllGazos
    query = %|select * from gazos order by id asc;|
    @results = @gazo_client.query(query)

    write_html('gazolist')
  end

  def newGazo
    # 最新のidを求める
    results = @gazo_client.query("select * from #{@gazo_table} order by id desc limit 1;")

    @gazo_newid = results.first['id'].to_i + 1

    print write_html('gazonew')
  end

  def setGazo(gazo, mode)
    # mysqlに登録する
    if (mode == 'new')
      # idを指定せず、REPLACEを使う
      # REPLACE -- INSERT と UPDATE の両方の働きをする。
      # cast -- MySQLの関数。datetime型に変換する。
      query = %|REPLACE INTO #{@gazo_table} (
            file, comment, ctype, image, created_at, updated_at)
            values (?, ?, ?, ?,
                cast("#{gazo.created_at}" as datetime),
                cast("#{gazo.updated_at}" as datetime))|
      statement = @gazo_client.prepare(query)
      results = statement.execute(gazo.file, gazo.comment,
                                  gazo.ctype, gazo.image)
      
      @notice = "登録しました。"
    elsif (mode == 'update')
      # idを指定しているので、UPDATEしてくれる。
      # その分、上の処理よりも、プレースホルダーの数が多い。
      query = %|REPLACE INTO #{@gazo_table} (
            id, file, comment, ctype, image, created_at, updated_at)
            values (?, ?, ?, ?, ?,
                cast("#{gazo.created_at}" as datetime),
                cast("#{gazo.updated_at}" as datetime))|
      statement = @gazo_client.prepare(query)
      results = statement.execute(gazo.id, gazo.file, gazo.comment,
                                  gazo.ctype, gazo.image)
      
      @notice = "更新しました。"
    end

    listAllGazos
  end

  def editGazo(id)
    selectGazo(id)
    print write_html('gazoedit')
  end

  def showGazo(id)
    selectGazo(id)
    print write_html('gazoshow')
  end

  def viewGazo(id)
    query = %|select ctype, image from #{gazo_table} where id = ?|
    statement = @gazo_client.prepare(query)
    @results = statement.execute(id)

    print render_view('gazoview')
  end

  def selectGazo(id)
    if id.integer?
      query = %|select * from #{@gazo_table} where id = ?|
      begin
        statement = @gazo_client.prepare(query)
        @results = statement.execute(id)
        sonzai = TRUE
      rescue => e
        @notice = "そのデータは存在しません。"
        sonzai = FALSE
      end
      return sonzai
    end
  end

  def deleteGazo(id)
    query = %|delete from #{@gazo_table} where id = ?|
    statement = @gazo_client.prepare(query)
    statement.execute(id)
    @notice = "削除しました。"
    listAllGazos
  end

  # テーブルの初期化とフィールドの設定
  def initGazo
    # もしテーブルが存在していたら、削除する。
    query = %|drop table if exists #{@gazo_table}|
    results = @gazo_client.quety(query)

    # テーブルgazosを作成する
    query = %|create table `#{@gazo_table}` (
      `id` int(11) not null auto increment,
      `file` varchar(255),
      `comment` varchar(255),
      `ctype` varchar(255),
      `image` blob,
      `created_at` datetime,
      `updated_at` datetime,
      PRIMARY KEY (`id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;|
    results = @gazo_client.query(query)
    @notice = "データベースを初期化しました。"
  end
end

##          cast("#{gazo.created_at}" as datetime),
##          cast("#{gazo.updated_at}" as datetime))|

