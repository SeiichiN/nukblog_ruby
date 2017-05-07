#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# データを1件表示

require './gazo.rb'
require 'cgi'

gazo_manager = GazoManager.new
cgi = CGI.new

id_moji = cgi['id']

if id_moji =~ /^[0-9]+$/
  id = id_moji.to_i
  sonzai = gazo_manager.editGazo(id)
else
  gazo_manager.listAllGazo
end
gazo_manager.client.close

