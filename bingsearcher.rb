require './searcher'

class BingSearcher < Searcher

    private

    def test_page
        'test-search-bing.htm'
    end

    def query_link(query)
        "http://bing.com/search?q=#{query}"
    end

    def results_section_from(results_page)
        results_page.css('div #results ul')
    end

    def html_links_from(results_section)
        results_section.css('li.sa_wr div.sb_tlst h3').css('a')
    end

end

"""
# print results
#BingSearcher.new.search_for('query').each do |link|
BingSearcher.new.test_search.each do |link|
    puts link.text
    puts link.href
    puts
end
"""

