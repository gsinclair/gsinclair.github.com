#!/usr/bin/env ruby

project = ARGV.shift || abort("No project name provided")

web_file = "#{project}.markdown"
orig_file = "../#{project}/doc/#{project}.markdown"

exec "mvim -d #{web_file} #{orig_file}"
