require './engines/engine'

class BingEnglishEngine < Engine

    def test_page
        'test-search-bing.htm'
    end

    def query_link_for(query)
        "http://www.bing.com/search?q=language:en+#{query}"
    end

    def html_links_from(results_page)
        results_section = results_page.css('div #results ul')

        results_section.css('li.sa_wr div.sb_tlst h3').css('a')
    end

end


"""
# print results
Searcher.new(BingEnglishEngine.new).search_for('abc').each do |link|
#Searcher.new(BingEngine.new).test_search.each do |link|
    puts link.text
    puts link.href
    puts
end
"""

