$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'pathname'
require 'bundler'
Bundler.setup
Bundler.require :cucumber

require 'order_book'

BASE_PATH = Pathname.new(__FILE__).dirname + '../..'
