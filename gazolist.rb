#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# 全リスト表示
require './gazo.rb'

gazo_manager = GazoManager.new

gazo_manager.listAllGazos

gazo_manager.client.close
