#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'cgi'
require './gazo.rb'

# gazoview.rb -- 画像だけを表示する。
# データベースの中の画像だけを表示する。
# データベースの中から画像データを削除したら、
# 必要なくなる。

cgi = CGI.new

moji_id = cgi['id']

id = moji_id.to_i

gazo_mng = GazoManager.new

gazo_mng.viewGazo(id)

gazo_mng.client.close
