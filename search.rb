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

class Scraper

    def initialize
        @searchers = {#:google => Searcher.new(GoogleEngine.new),
                      #:yahoo => Searcher.new(YahooEngine.new),
                      :bing => Searcher.new(ProxiedEngine.new(BingEngine.new))}

        @queries = [#'google bought motorola',
                    #'george bush planned 9/11 atacks',
                    'when did titanic sank?']
    end

    def showtime
        all_results = {}

        @queries.each do |query|
            query_results = {}

            @searchers.each do |symbol, searcher|
                query_results[symbol] = results_from searcher.search_for query
            end

            all_results[query] = query_results
        end

        all_results
    end

    def results_from(ordered_links)
        ordered_links.map do |link|
            Result.new link.text,
                       link.href,
                       ordered_links.index(link),
                       fetch_page_from(link)
        end
    end

    def fetch_page_from link
        agent = Mechanize.new
        agent.user_agent_alias = 'Linux Firefox'

        agent.get(link.href).body
    end

end

#TODO persist all_results
#pp all_results
pp Scraper.new.showtime

require "yaml"

def save(output_file, obj)
    dump = YAML::dump(obj)

    File.open(output_file, "w") do |file|
        file.puts dump
    end
end

def retrieve(input_file)
    File.open(input_file) do |file|
        return YAML::load file.read
    end
end

"""
file_name = 'queries.yaml'
save(file_name, queries)
q = retrieve(file_name)
"""


#Testing-----------------------------------------------------------------------
"""
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
"""
