#!/home/se-ichi/.rbenv/shims/ruby
# coding: utf-8

require 'erb'
require 'cgi'

puts 'Content-Type: text/html; charset=utf-8'
puts ''
body = ERB.new(File.read('hello.erb'))
body.run

cgi = CGI.new
pathinfo = cgi.path_info
pathtranslated = cgi.path_translated

print "path_info= #{pathinfo}\n"
print "path_translated= #{pathtranslated}\n"
