#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# データベースの初期化

require './blog.rb'

blog_manager = BlogManager.new

blog_manager.initBlog
