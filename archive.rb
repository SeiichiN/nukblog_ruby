#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# 一覧表示

require './blog.rb'


blog_manager = BlogManager.new

cookie = {"name" => "updated_at", "value" => "desc"}

blog_manager.archiveBlog(cookie)

blog_manager.client.close
