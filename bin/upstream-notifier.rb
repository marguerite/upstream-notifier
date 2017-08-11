#!/usr/bin/env ruby

$LOAD_PATH.push(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'upstream_notifier'

config = UpstreamNotifier::Config.parse('fcitx')

UpstreamNotifier::Parser.new(config).parse
