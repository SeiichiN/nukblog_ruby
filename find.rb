#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# このプログラムは、archive.html.erbからのformのpost値を受け取る。
# search -- 検索対象(title, body, category, tag)
# search_word -- 検索のことば

require './blog.rb'
require 'cgi'

cgi = CGI.new

blog_manager = BlogManager.new

if !cgi['search_word'].empty?
  genre = CGI.escapeHTML(cgi['search'])
  word = CGI.escapeHTML(cgi['search_word'])

  blog_manager.findBlog(genre, word)
else
  cookie = {'name' => 'updated_at', 'value' => 'desc'}
  blog_manager.archiveBlog(cookie)
end

blog_manager.client.close
