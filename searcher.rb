
require 'nokogiri'
require 'mechanize'

class Searcher

    def search_for(query)
        extract_results_from results_page_for query
    end

    def test_search
        extract_results_from test_results_page
    end

    private

    def extract_results_from(page)
        results_section = results_section_from(page)

        html_links = html_links_from(results_section)

        to_links(html_links)
    end

    def test_results_page
        doc = nil
        File.open(test_page) do |file|
            doc = Nokogiri.HTML(file)
        end
        doc
    end

    def results_page_for(query)
        agent = Mechanize.new
        agent.get(query_link(query)).parser
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
