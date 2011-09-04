#!/usr/bin/env ruby

require './scraper'
require './marshalrepository'

queries = ['google bought motorola',
           'george bush planned 9/11 attacks',
           'when did titanic sink?',
           '"a christmas carol" "charles dickens" books free download',
           'parfum diva by ungaro 50 ml buy',
           'Gunther Jakobs law for the enemy',
           'what is the best chilean wine',
           'how to make shrimp stuffed potatoes',
           'johnson bros england history',
           'manolo blahnik shoes',
           'internet traffic chart web dead',
           'documentary health care united states michael moore',
           'inheritance versus mixins in ruby',
           'web scraping ruby mechanize',
           'how to handle exceptions in java',
           'google web toolkit json rpc',
           'how to extrude a surface in autocad',
           'anonymous attacks visa mastercard wikileaks',
           'sony psn outage 2011',
           'space debris shuttle damage',
           'bin laden dead pictures leaked',
           'marvel avengers movie premiere',
           'khan academy ted talk',
           'richard dawkins the virus of faith',
           'richard dawkins the blind watchmaker']

scraping_results = Scraper.new(queries).showtime

repository = MarshalRepository.new 'scraped-data'
repository.save scraping_results


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
