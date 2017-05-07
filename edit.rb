#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# 1件データの編集

require './blog.rb'
require 'cgi'

blog_manager = BlogManager.new
cgi = CGI.new

num_moji = cgi['id']
if num_moji =~ /^[0-9]+$/
  id = num_moji.to_i
  blog_manager.editBlog(id)
else
  blog_manager.archiveBlog
end

blog_manager.client.close
