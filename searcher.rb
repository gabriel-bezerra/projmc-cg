require 'nokogiri'
require 'mechanize'

class Searcher

    def initialize engine
        @engine = engine
    end

    def search_for(query)
        extract_results_from @engine.results_page_for(query)
    end

    def test_search
        extract_results_from @engine.test_results_page
    end

    private

    def extract_results_from(page)
        html_links = @engine.html_links_from(page)
        to_links(html_links)
    end

    # creates Mechanize::Page::Links from the html links because it is easier to
    # use
    def to_links(html_links)
        links = []

        html_links.each do |link_node|
           links.push Mechanize::Page::Link.new(link_node, nil, nil)
        end

        links
    end

end

