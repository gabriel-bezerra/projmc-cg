require './engine'

class GoogleEngine < Engine

    def test_page
        'test-search-google.htm'
    end

    def query_link(query)
        "http://www.google.com/search?q=#{query}"
    end

    def html_links_from(results_page)
        results_section = results_page.css('div #ires ol')

        results_section.css('h3.r a.l')
    end

end


"""
require './searcher'

# print results
#Searcher.new(GoogleEngine.new).search_for('query').each do |link|
Searcher.new(GoogleEngine.new).test_search.each do |link|
    puts link.text
    puts link.href
    puts
end
"""

