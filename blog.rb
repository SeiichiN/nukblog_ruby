#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'date'
require 'mysql2'
require 'erb'
require './hikidoc'
require 'yaml'

# ブログ1件分のクラスをつくる
class Blog
  # インスタンス初期化
  def initialize( id, title, body, category, tag, created_at, updated_at, count )
    @id = id
    @title = title
    @body = body
    @category = category
    @tag = tag
    @created_at = created_at
    @updated_at = updated_at
    @count = count
  end

  # 属性に対するアクセサ
  attr_accessor :id, :title, :body, :category, :tag, :created_at, :updated_at, :count

  # インスタンスの文字列表現
  def to_s
    "#{@id}, #{@title}, #{@body}, #{@category}, #{@tag},#{@created_at}, #{@updated_at}, #{@count}"
  end

  # データを書式をつけて出力する
  # 項目の区切り文字を引数に指定できる
  # 引数を省略した場合は、改行を区切り文字とする
  def toFormattedString( sep = "\n" )
    "#{@id}#{sep}#{@title}#{sep}#{@body}#{sep}カテゴリ：#{@category}#{sep}タグ：#{@tag}#{sep}作成日：#{@created_at}#{sep}更新日：#{@updated_at}#{sep}カウント：#{@count}#{sep}"
  end

  def to_html
    HikiDoc.to_html(@body)
  end

end

class BlogManager
  def initialize
    db = YAML.load_file("database.yml")
    
    # データベースに接続
    @client = Mysql2::Client.new(
      :host => "#{db['blog']['host']}",
      :username => "#{db['blog']['username']}",
      :password => "#{db['blog']['password']}",
      :socket => "#{db['blog']['socket']}",
      :encoding => "#{db['blog']['encoding']}",
      :database => "#{db['blog']['database']}"
    )
    @table_name = "#{db['blog']['table']}"
  end

  attr_accessor :client, :table_name

  def render_view(template)
    rhtml = ERB.new(File.read("view/#{template}.html.erb"))
    rhtml.result(binding)
  end

  def write_html(name, template = 'layout')
    @content = render_view(name)
    print render_view(template)
  end

  def infoBlog
    print write_html('info') 
  end

  def listAllBlog
    query = %|select * from #{@table_name} order by id desc|
    @results = @client.query(query)
    
    print write_html('list')
  end

  def homeBlog
    query = %|select * from #{@table_name} order by updated_at desc limit 3|
    @results = @client.query(query)

    @homecontent = []
    @results.each do |row|
      id = row['id'].to_i
      selectBlog(id)
#      @content = render_view('homecontent')
      @homecontent << render_view('homecontent')
    end

    print write_html('home')
  end

  def archiveBlog(ganle = 'updated_at', order = 'desc')
    query = %|select * from #{@table_name} order by #{ganle} #{order}|
    @results = @client.query(query)
    
    print write_html('archive')
  end

  def showBlog(id)
    selectBlog(id)
    print write_html('show')
  end

  def addBlog
    # 前回のinsertのときのauto_incrementの値を求める
    results = @client.query("select * from #{@table_name} order by id desc limit 1;")
    
    @newid = "#{results.first['id']}".to_i + 1

    print write_html('new')
  end


  def setBlog(blog, mode)
    # mysqlに登録する
    if (mode == 'new')
      query = %|insert into #{@table_name} values (
        #{blog.id}, '#{blog.title}', '#{blog.body}',
        cast("#{blog.created_at}" as datetime),
        cast("#{blog.updated_at}" as datetime),
        '#{blog.category}', '#{blog.tag}', #{blog.count}
      )|
    elsif (mode == 'update')
      esc_title = @client.escape("#{blog.title}")
      esc_body = @client.escape("#{blog.body}")
      query = %|update #{@table_name} set
        title =  '#{esc_title}',
        body =   '#{esc_body}',
        created_at = cast("#{blog.created_at}" as datetime),
        updated_at = cast("#{blog.updated_at}" as datetime),
        category = '#{blog.category}',
        tag =  '#{blog.tag}',
        count = #{blog.count} where id = #{blog.id}| 
    end
    
    results = @client.query(query)
    @notice =  "登録しました。"
    archiveBlog
  end
    
  # idを引数にとって、そのデータを選択する。
  # 該当データが存在したら、表示して TRUE を返す。
  # 存在しなければ、FALSE を返す。
  def selectBlog(id)
    if id.integer?
      # mysqlから1件データを抽出して表示
      query = %|select * from #{@table_name} where id = #{id}|
      # 存在しないデータを指定した場合は、メッセージを返す。
      begin
        @results = @client.query(query)
        entry = @results.first
        @this_blog = Blog.new(id, entry['title'], entry['body'],
                              entry['category'], entry['tag'],
                              entry['created_at'], entry['updated_at'],
                              entry['count'].to_i + 0)
        
        sonzai = TRUE
      rescue => e
        puts "<p>そのデータは存在しません。</p>"
        sonzai = FALSE
      end
      return sonzai
    else
      @notice = '数字ではないね。'
    end
  end

  def editBlog(id)
    selectBlog(id)
    print write_html('edit')
  end
    
  # 本当に削除するか確認
  def sureDeleteBlog(id)
    selectBlog(id)
    print write_html('sure')
  end
  
  # データを削除する
  def deleteBlog(id)
    query = %|delete from #{@table_name} where id = #{id}|
    results = @client.query(query)
    @notice = '削除しました'
    archiveBlog
  end

  # テーブルの初期化とフィールドの設定
  def initBlog
    # もし、テーブルが存在してたら、削除する。
    query = %|drop table if exists #{@table_name}|
    results = @client.query(query)

    # テーブルentriesを作成する。
    query = %|create table `#{@table_name}` (
      `id` int(11) not null auto_increment,
      `title` varchar(255) COLLATE utf8_unicode_ci,
      `body` text COLLATE utf8_unicode_ci,
      `created_at` datetime,
      `updated_at` datetime,
      `category` varchar(255),
      `tag` varchar(255),
      `count` int(11),
      PRIMARY KEY (`id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;|
    results = @client.query(query)
    @notice = "データベースを初期化しました。"
  end
  
end

