# -*- coding: utf-8 -*-
require 'webrick'

# サーバー設定
config = {
  :Port => 8099,
  :DocumentRoot => './',
  :CGIInterpreter => 'D:\Ruby23-x64\bin\ruby.exe -Eutf-8:utf-8',
}

# 拡張子erbのファイルとERBHandlerとを関連づける
#WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)

module WEBrick::HTTPServlet
  FileHandler.add_handler('rb', CGIHandler)
end

# WEBrick の HTTP Server クラスのインスタンスを作成する
server = WEBrick::HTTPServer.new(config)

# erbのMIMEタイプを設定
server.config[:MimeTypes]["erb"] = "text/html"
#server.config[:MimeTypes]["rhtml"] = "text/html"

# Ctrl-C 割り込みがあった場合にサーバーを停止する処理を登録
trap(:INT) do
  server.shutdown
end

# サーバー開始
server.start
