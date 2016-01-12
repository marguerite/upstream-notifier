#!/usr/bin/env ruby

require 'fileutils'

def duplicate(file="")

	list = Array.new

	open(file,'r:UTF-8') { |f| f.each_line { |l| list << l } }

	open(file + ".new",'w:UTF-8') { |f| list.uniq!.each { |i| f.puts i } }

	FileUtils.mv(file + ".new",file)

end

duplicate(ARGV[0])
