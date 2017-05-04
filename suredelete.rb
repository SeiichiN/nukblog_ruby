#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# 1件データの削除

require './blog.rb'
require 'cgi'

blog_manager = BlogManager.new
cgi = CGI.new

id = cgi['id'].to_i

blog_manager.sureDeleteBlog(id)
