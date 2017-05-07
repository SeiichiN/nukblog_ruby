#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require './dbase.rb'
require 'mysql2'
require 'yaml'

# gazoconv.rb -- ユーティリティ
# データベースにある画像（バイナリデータ）を
# imageフォルダの中にファイルとして保存する。
# ただ、一回一回保存していいか尋ねる。
# なぜかというと、データベースに保存している
# ファイル名でいいかどうかがあるからである。

class GazoConv < BaseDb
end

gazo_conv = GazoConv.new

query = %|select * from #{gazo_conv.gazo_table} order by id asc|

results = gazo_conv.client.query(query)

results.each do |gazo|
  id = gazo['id']
  image = gazo['image']
  filename = gazo['file']
  print "id= #{id}  filename= #{filename} \n"
  print "convert? (y/n) > "
  yesno = gets.chomp
  if (yesno.downcase == 'y')
    File.open "images/#{filename}", 'wb' do |f|
      f.write image
    end
  end
end

puts '画像をimagesフォルダに保存しました。'
