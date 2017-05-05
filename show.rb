#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# データを1件表示

require './blog.rb'
require 'cgi'

blog_manager = BlogManager.new
cgi = CGI.new

id_moji = cgi['id']
if id_moji =~ /^[0-9]+$/
  id = id_moji.to_i
  sonzai = blog_manager.showBlog(id)
else
  blog_manager.archiveBlog
end
