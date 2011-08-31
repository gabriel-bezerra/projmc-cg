#!usr/bin/env ruby

require './searcher'
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
r1 = Searcher.new(GoogleEngine.new).search_for query
show_these_links r1

puts 'YAHOO!------------------------------------------------------------------'
r2 = Searcher.new(YahooEngine.new).search_for query
show_these_links r2

puts 'BING--------------------------------------------------------------------'
r3 = Searcher.new(BingEngine.new).search_for query
show_these_links r3

puts 'PROXIED BING------------------------------------------------------------'
r4 = Searcher.new(ProxiedEngine.new(BingEngine.new)).search_for query
show_these_links r4

