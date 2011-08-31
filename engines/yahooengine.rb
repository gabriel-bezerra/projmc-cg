require './engine'

class YahooEngine < Engine

    def test_page
        'test-search-yahoo.htm'
    end

    def query_link_for(query)
        "http://search.yahoo.com/search?p=#{query}"
    end

    def html_links_from(results_page)
        results_section = results_page.css('div #web ol')

        results_section.css('a.yschttl')
    end

end


"""
require './searcher'

# print results
#Searcher.new(YahooEngine.new).search_for('query').each do |link|
Searcher.new(YahooEngine.new).test_search.each do |link|
    puts link.text
    puts link.href
    puts
end
"""

