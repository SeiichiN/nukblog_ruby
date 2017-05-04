#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# このプログラムは、new.html.erbとedit.html.erbからのformのpost値を
# 受け取る。
# newかeditのどちらかがmodeに代入され、blog.rbのsetDataに処理が
# 渡される。

require './blog.rb'
require 'cgi'

cgi = CGI.new

id = cgi['id'].to_i
title = CGI.escapeHTML(cgi['title'])
body = (cgi['body'])
category = CGI.escapeHTML(cgi['category'])
tag = CGI.escapeHTML(cgi['tag'])
created_year = cgi['created-year']
created_month = cgi['created-month']
created_day = cgi['created-day']
created_hour = cgi['created-hour']
created_min = cgi['created-min']
created_sec = cgi['created-sec']
created_at = %|#{created_year}-#{created_month}-#{created_day} #{created_hour}:#{created_min}:#{created_sec}|

updated_year = cgi['updated-year']
updated_month = cgi['updated-month']
updated_day = cgi['updated-day']
updated_hour = cgi['updated-hour']
updated_min = cgi['updated-min']
updated_sec = cgi['updated-sec']
updated_at = %|#{updated_year}-#{updated_month}-#{updated_day} #{updated_hour}:#{updated_min}:#{updated_sec}|

# newならcountは0になっているはずだし、editなら+1しても別にかまわんだろ。
count = cgi['count'].to_i + 1

# modeは、'new' か 'update' のどちらかである。
mode = cgi['mode']

if ((mode == 'new') || (mode == 'update'))
  # 入力した値でblogインスタンスを作成する。
  blog = Blog.new(id, title, body, category, tag, created_at, updated_at, count)

  # 確認用
  # print blog.toFormattedString

  blog_manager = BlogManager.new

  # blog_manager.setBlogに blogインスタンスとmodeをわたす。
  blog_manager.setBlog(blog, mode)    
end

blog_manager.archiveBlog


