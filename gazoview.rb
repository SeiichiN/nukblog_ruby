#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'cgi'
require './gazo.rb'

cgi = CGI.new

moji_id = cgi['id']

id = moji_id.to_i

gazo_mng = GazoManager.new

gazo_mng.viewGazo(id)

gazo_mng.client.close
