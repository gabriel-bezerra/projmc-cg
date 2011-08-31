require './searcher'

class GoogleSearcher < Searcher

    def initialize
        @test_page = 'test-search-google.htm'
    end

    private

    def query_link(query)
        "http://www.google.com/search?q=#{query}"
    end

    def results_section_from(results_page)
        results_page.css('div #ires ol')
    end

    def html_links_from(results_section)
        results_section.css('h3.r a.l')
    end

end

"""
# print results
#GoogleSearcher.new.search_for('query').each do |link|
GoogleSearcher.new.test_search.each do |link|
    puts link.text
    puts link.href
    puts
end
"""

