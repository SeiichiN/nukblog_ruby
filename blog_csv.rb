# -*- coding: utf-8 -*-
require 'date'
require 'pstore'

# ブログ1件分のクラスをつくる
class Blog
  # インスタンス初期化
  def initialize( id, title, body, category, tag, created_at, modified_at, count )
    @id = id
    @title = title
    @body = body
    @category = category
    @tag = tag
    @created_at = created_at
    @modified_at = modified_at
    @count = count
  end

  # 属性に対するアクセサ
  attr_accessor :id, :title, :body, :category, :tag, :created_at, :modified_at, :count

  # インスタンスの文字列表現
  def to_s
    "#{@id}, #{@title}, #{@body}, #{@category}, #{@tag},#{@created_at}, #{@modified_at}, #{@count}"
  end

  # CSV形式に変換する
  def to_csv(key)
    "#{key},#{@id},#{@title}, #{@body}, #{@category}, #{@tag},#{@created_at}, #{@modified_at}, #{@count}\n"
  end

  # データを書式をつけて出力する
  # 項目の区切り文字を引数に指定できる
  # 引数を省略した場合は、改行を区切り文字とする
  def toFormattedString( sep = "\n" )
    "#{@id}#{sep}#{@title}#{sep}#{@body}#{sep}カテゴリ： #{@category}#{sep}タグ： #{@tag}#{sep}作成日： #{@created_at}#{sep}更新日： #{@modified_at}#{sep}カウント： #{@count}#{sep}"
  end
end

class BlogManager
  def initialize(pstore_name)
    @db = PStore.new(pstore_name)
  end

#  def setUp
#    open(@csv_fname, "r:UTF-8") { |file|
#      file.each { |line|
#        key, id, title, body, category, tag, created_at, modified_at, count = line.chomp.split(',')
#        @blogs[key] = Blog.new(
#          id, title, body, category, tag, created_at, modified_at, count)
#      }
#    }
#  end

  def lastId
    num = 0
    @db.transaction(true) do
      # roots -- キーの配列を返す
      @db.roots.each { |key|
        num = key
      }
    end
    return num
  end

  def addBlog
    blog = Blog.new(0, "", "", "", "", "", "", 0)
    print "\n"
    key = lastId.to_i + 1
    print "id(key): #{key}\n"
    blog.id = key
    print "title: "
    blog.title = gets.chomp
    print "body: "
    blog.body = gets.chomp
    print "カテゴリ： "
    blog.category = gets.chomp
    print "タグ： "
    blog.tag = gets.chomp
    print "created_at: #{Date.today}\n"
    blog.created_at = Date.today
    print "modified_at: #{Date.today}\n"
    blog.modified_at = Date.today
    print "カウント： "
    blog.count = gets.chomp.to_i

    # 作成した1件分のデータをPStoreデータベースに保存する
    @db.transaction do
      # 蔵書データをPStoreに保存する
      @db[key] = blog
    end

  end

  def listAllBlog
    puts "\n---------------------------"
    @db.transaction(true) do  # 読み込みモード
      # rootsがキーの配列を返し、eachでそれを1件ずつ処理
      @db.roots.each do |key|
        #得られたキーを使ってPStoreからデータを取得
        puts "キー： #{key}"
        print @db[key].toFormattedString
        puts "\n---------------------------"
      end
    end
  end

  # データを削除する
  def delBlog
    # キーを指定して削除
    print "\n"
    print "id(key)を指定してください："
    key = gets.chomp

    # 削除対象データを確認してから削除する
    @db.transaction do
      if @db.root?(key)
        print @db[key].toFormattedString
        print "\n削除しますか？（ Y/y なら削除を実行）"
        # 大文字に変える
        yesno = gets.chomp.upcase
        if /^Y$/ =~ yesno
          # Yが1文字のときだけ削除実行
          @db.delete(key)
          puts "\nデータベースから削除しました。"
        end
      end
    end
  end
  
        
#  def saveAllBlog
#    open(@csv_fname, "w:UTF-8") { |file|
#      @blogs.each { |key, oneblog|
#        file.print( oneblog.to_csv(key) )
#      }
#      puts "\nファイルへ保存しました。"
#    }
#  end

  # 処理の選択
  def run
    while true
      print "
1.データの登録
2.データの表示
3.データの削除
9.終了

選択(1, 2, 8, 9)> "

      num = gets.chomp
      case
      when '1' == num
        addBlog
      when '2' == num
        listAllBlog
      when '3' == num
        delBlog
      when '9' == num
        break
      else
      end
    end
  end
end


# Blogクラスのインスタンスを作成し、blogという名前をつける

blog_manager = BlogManager.new("blog.db")

blog_manager.run

