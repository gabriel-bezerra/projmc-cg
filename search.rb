#!usr/bin/env ruby

require 'rubygems'
require 'mechanize'

require './googlesearcher'
require './yahoosearcher'
require './bingsearcher'
require './bingproxiedsearcher'

#Testing-----------------------------------------------------------------------

def show_these_links(links)
    links.each do |link|
        puts link.text
        puts link.href
        puts
    end
end

query = 'inheritance in ruby'

puts 'GOOGLE------------------------------------------------------------------'
r1 = GoogleSearcher.new.search_for query
show_these_links r1

puts 'YAHOO!------------------------------------------------------------------'
r2 = YahooSearcher.new.search_for query
show_these_links r2

puts 'BING--------------------------------------------------------------------'
r3 = BingSearcher.new.search_for query
show_these_links r3

puts 'PROXIED BING------------------------------------------------------------'
r4 = BingProxiedSearcher.new.search_for query
show_these_links r4
