
require "./searcher"
require "./engines/bingengine"
require "./engines/bingenglishengine"
require "./engines/proxiedengine"

#Testing-----------------------------------------------------------------------
def show_these_links(links)
    links.each do |link|
        puts link.text
        puts link.href
        puts
    end
end

#query = 'inheritance in ruby'
query = 'abc'
"""

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

puts 'ENGLISH BING------------------------------------------------------------'
r5 = Searcher.new(BingEnglishEngine.new).search_for query
show_these_links r5
"""

