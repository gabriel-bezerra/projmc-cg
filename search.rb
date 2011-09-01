#!usr/bin/env ruby

require './searcher'
require './engines/googleengine'
require './engines/yahooengine'
require './engines/bingengine'
require './engines/proxiedengine'

class Result
    attr_reader :title, :url, :rank, :page
    
    def initialize title, url, rank, page
        @title = title
        @url = url
        @rank = rank
        @page = page
    end
end


def show_these_links(links)
    links.each do |link|
        puts link.text
        puts link.href
        puts
    end
end

searchers = {:google => Searcher.new(GoogleEngine.new),
             :yahoo  => Searcher.new(YahooEngine.new),
             :bing   => Searcher.new(ProxiedEngine.new(BingEngine.new))}

queries = [#'google bought motorola',
           #'george bush planned 9/11 atacks',
           'when did titanic sank?']

all_results = {}

def fetch_page link
    agent = Mechanize.new
    agent.user_agent_alias = 'Linux Firefox'

    agent.get(link.href).body
end

queries.each do |query|
    query_results = {}
    
    searchers.each do |symbol, searcher|
        results = []
        
        links = searcher.search_for query
        links.each do |link|
            results.push Result.new link.text, link.href, links.index(link), fetch_page(link)
        end
        
        query_results[symbol] = results
    end
    
    all_results[query] = query_results
end

#TODO persist all_results
#pp all_results

#Testing-----------------------------------------------------------------------
"""
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
"""
