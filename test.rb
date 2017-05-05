#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'cgi'

cgi = CGI.new('html5')
rcookies = cgi.cookies

scookies = []
scookies << CGI::Cookie.new({'name' => 'test-cookie',
                             'value' => ['foo', 'bar', 'baz'],
                             'domain' => cgi.server_name,
                             'path' => cgi.script_name,
                             'expires' => Time.now + 600})

cgi.out({'charset' => 'utf-8',
         'cookie' => scookies}) do
  cgi.html({'PRETTY' => '  '}) do
    cgi.head do
      cgi.title {'Example 03-6'}
    end
    + cgi.body do
      cgi.h1{'ブラウザが送ったクッキー'}
      + cgi.ul {rcookies.collect {|name, cookie|
                  cgi.li {name + ': ' + CGI::escapeHTML(cookie.to_s)}
                }.join()
      }
      + cgi.h1 {'ブラウザヘ送ったクッキー'}
      + cgi.ul {scookies.collect {|cookie|
                  cgi.li {CGI::escapeHTML(cookie.to_s)}
                }.join()
      }
    end
  end
end

