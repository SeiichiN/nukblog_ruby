#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# info.rb

require './blog.rb'

blog_manager = BlogManager.new

blog_manager.infoBlog

blog_manager.client.close
