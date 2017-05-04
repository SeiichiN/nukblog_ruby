#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# gazonew.html.erbからのデータを受け取るプログラム。

require './gazo.rb'
require 'cgi'
require 'mime-types'
require 'date'
require 'base64'

cgi = CGI.new

gazo = Gazo.new(0, '', '', '', '', '', '')
gazo.id = cgi['id']
#id = nil
gazo.file = CGI.escapeHTML(cgi['filename'])
gazo.comment = CGI.escapeHTML(cgi['comment'])
gazo.ctype = MIME::Types.type_for(gazo.file).first.to_s
# readメソッドは画像を末尾までテキストとして読み込む働きをしているっぽい。
gazo.image = cgi['file'].read
gazo.created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
gazo.updated_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")


# バイナリデータをbase64でエンコードする。
# そうしないと、umcompatible ASCII-8BIT and UTF-8 のエラーが起きる。
# force_encodint('utf-8')としても、文字列がそのまま出力されるだけである。
encimage = Base64.strict_encode64(gazo.image)

# modeは、'new' か 'update' のどちらかである。
mode = cgi['mode']

if ((mode == 'new') || (mode == 'update'))
  # 確認用]
  #print "Content-Type: text/html; charset=utf-8\n\n"
  #print gazo.toFormattedString

  gazo_manager = GazoManager.new

  query = %|REPLACE INTO #{gazo_manager.gazo_table} (
      file, comment, ctype, image, created_at, updated_at)
      values ('#{gazo.file}', '#{gazo.comment}', '#{gazo.ctype}',
      '#{encimage}',
      cast("#{gazo.created_at}" as datetime),
      cast("#{gazo.updated_at}" as datetime))|
  
#  gazo_manager.gazo_client.query(query)
  
  # gazo_manager.setGazoに gazoインスタンスとmodeをわたす。
#  gazo_manager.setGazo(gazo, mode)    
end

#gazo_manager.listAllGazos


#encimage = gazo.image
# ====================================================
# うまく表示できた！
#print "Content-Type: text/html; charset=utf-8\n\n"
#print "<html><body>"
#print "<img src='data:#{ctype};base64,#{image}'>"
#print "</html></body>"
# ====================================================

# 確認用出力
str = <<EOS
<html>
<body>
<h1>確認</h1>
id>         #{gazo.id}<br>
filename>   #{gazo.file}<br>
<img src="data:#{gazo.ctype};base64, #{encimage}"><br>
comment>    #{gazo.comment}<br>
ctype>      #{gazo.ctype}<br>
created_at> #{gazo.created_at}<br>
updated_at> #{gazo.updated_at}<br>
</body>
</html>
EOS

print "Content-Type: text/html; charset=utf-8\n\n"
print str

