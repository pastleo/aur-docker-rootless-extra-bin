#!/usr/bin/env ruby

require 'net/http'
REGEX = /docker-rootless-extras-(\d+\.\d+\.\d+).tgz/

response = Net::HTTP.get_response(URI('https://download.docker.com/linux/static/stable/x86_64/'))
max_version = response.body.scan(REGEX).flatten.sort do |a, b|
  pair = a.split('.').zip(b.split('.')).find {|a, b| a != b }
  if pair
    Integer(pair[0]) <=> Integer(pair[1])
  else
    0
  end
end.last

puts "latest version: #{max_version}, writing to PKGBUILD..."

`sed -i 's/pkgver=.*/pkgver=#{max_version}/' PKGBUILD`

puts 'Done, run this to make and install:'
puts '  makepkg -si'
