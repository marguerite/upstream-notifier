#!/usr/bin/env ruby

$LOAD_PATH.push(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'upstream_notifier'

config = UpstreamNotifier::Config.new(ARGV[0])
option = UpstreamNotifier::Config.new('option', 'option')

newconfig = UpstreamNotifier::Parser.new(config.parse, option.parse).parse

config.write(newconfig)
