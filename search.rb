#!usr/bin/env ruby

require './scraper'
require './marshalrepository'

queries = ['google bought motorola',
           'george bush planned 9/11 attacks',
           'when did titanic sank?',
           '"a christmas carol" "charles dickens" books free download',
           'parfum diva by ungaro 50 ml buy',
           'Gunther Jakobs law for the enemy',
           'what is the best chilean wine',
           'how to make shrimp stuffed potatoes']

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
