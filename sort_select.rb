#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require './blog.rb'
require 'cgi'

blog_manager = BlogManager.new
cgi = CGI.new

# archive.html.erbからpostで送られてくる
# 送られてきたname値からwordに項目名をセットする
key = 0
if !cgi['title'].empty?
  word = 'title'
end
if !cgi['category'].empty?
  word = 'category'
end
if !cgi['tag'].empty?
  word = 'tag'
end
if !cgi['count'].empty?
  word = 'count'
end
if !cgi['created_at'].empty?
  word = 'created_at'
end
if !cgi['updated_at'].empty?
  word = 'updated_at'
end

# ここで実際にPOSTされてきた値を受け取る（値は1）
# keyには1が入る
key = cgi[word].to_i

# cookiesにその項目名でクッキーがあれば、セットする。
# クッキー値はゼロか1である
rcookie = cgi.cookies[word].first
if rcookie
  val = rcookie.to_i
else # なければ、ゼロ
  val = 0
end

# valはゼロか1である
val = (val + key) % 2

# クッキーにその項目名で値（0か1）をセットする
# expiresをセットしていないので、ブラウザを閉じるまでが有効期限である。
cookie = CGI::Cookie.new({'name' => word,
                          'value' => val.to_s})

# ヘッダ情報に書き出して、クッキー値を保存する。
print cgi.header({'cookie' => cookie})
  
if (val  == 1)
  blog_manager.archiveBlog(word, 'desc')
else
  blog_manager.archiveBlog(word, 'asc')
end


