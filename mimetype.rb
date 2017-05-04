#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# 拡張子からMIMEタイプを判別する。
# ( 参考 )
# RubyにおけるMIME型判別ライブラリの比較
# http://d.hatena.ne.jp/keita_yamaguchi/20070805/1186304326

require 'mime-types'

path = './img/archive.png'

puts MIME::Types.type_for(path).first.to_s

