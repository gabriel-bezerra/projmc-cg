require './searcher'

class YahooSearcher < Searcher

    private

    def test_page
        'test-search-yahoo.htm'
    end

    def query_link(query)
        "http://search.yahoo.com/search?p=#{query}"
    end

    def results_section_from(results_page)
        results_page.css('div #web ol')
    end

    def html_links_from(results_section)
        results_section.css('a.yschttl')
    end

end

"""
# print results
#YahooSearcher.new.search_for('query').each do |link|
YahooSearcher.new.test_search.each do |link|
    puts link.text
    puts link.href
    puts
end
"""

