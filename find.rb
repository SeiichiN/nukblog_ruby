#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# このプログラムは、archive.html.erbからのformのpost値を受け取る。
# search -- 検索対象(title, body, category, tag)
# search_word -- 検索のことば

require './blog.rb'
require 'cgi'

cgi = CGI.new

genre = CGI.escapeHTML(cgi['search'])
word = CGI.escapeHTML(cgi['search_word'])

blog_manager = BlogManager.new

blog_manager.findBlog(genre, word)
