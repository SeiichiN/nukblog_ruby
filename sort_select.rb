#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require './blog.rb'
require 'cgi'

blog_manager = BlogManager.new
cgi = CGI.new

word = cgi.keys.first
num = cgi[word].to_i

if num == 1
    order = 'desc'
elsif num == 0
    order = 'asc'
end

#print "Content-Type: text/html\n\n"
#print "word=#{word}  num=#{num}   word=#{word} order=#{order}\n"

cookie = {"name" => word, "value" => order}

# これで、クッキーの値を取り出すときは、どうすんだ？
# cookies['category']['value'] で、categoryの値を取り出せるのかな？

blog_manager.archiveBlog(cookie)



