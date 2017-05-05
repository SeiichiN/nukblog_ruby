#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# 1件データの削除

require './gazo.rb'
require 'cgi'

gazo_manager = GazoManager.new
cgi = CGI.new

id = cgi['id'].to_i

gazo_manager.deleteGazo(id)

gazo_manager.gazo_client.close

