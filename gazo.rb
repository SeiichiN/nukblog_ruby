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
      :host => "#{db['gazo']['host']}",
      :username => "#{db['gazo']['username']}",
      :password => "#{db['gazo']['password']}",
      :socket => "#{db['gazo']['socket']}",
      :encoding => "#{db['gazo']['encoding']}",
      :database => "#{db['gazo']['database']}"
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
      query = %|REPLACE INTO #{@gazo_table} (
            file, comment, ctype, image, created_at, updated_at)
            values ('#{gazo.file}', '#{gazo.comment}', '#{gazo.ctype}',
            #{gazo.image},
            cast("#{gazo.created_at}" as datetime),
            cast("#{gazo.updated_at}" as datetime))|
    end

    results = @gazo_client.query(query)
    @notice = "登録しました。"
    listAllGazos
  end

  def showGazo(id)
    selectGazo(id)
    print write_html('gazoshow')
  end

  def selectGazo(id)
    if id.integer?
      query = %|select * from #{@gazo_table} where id = #{id}|
      begin
        @results = @gazo_client.query(query)
        sonzai = TRUE
      rescue => e
        @notice = "そのデータは存在しません。"
        sonzai = FALSE
      end
      return sonzai
    end
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

