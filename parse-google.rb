
require 'nokogiri'
require 'mechanize'

class GoogleSearcher

    def search(query)
        page = get_results_page(query)
        results_section = get_results_section(page)

        html_links = get_html_links(results_section)
        clean_links(html_links)

        to_links(html_links)
    end

    private

    def get_results_page(query)
        agent = Mechanize.new
        agent.get("http://www.google.com/search?q=#{query}").parser
    end

    def get_results_section(results_page)
        results_page.css('div#ires ol')
    end

    # get links from results section
    def get_html_links(results_section)
        result_links = []

        results_section.css('a.l').each do |link|
            result_links.push link
        end

        result_links
    end


    # links must start with http://
    def clean_links(html_links)
        html_links.each do |node|
            unless /^http:\/\// =~ node.attribute('href')
                actual_url = node.attribute('href').content.sub(/^.*http:\/\//, 'http://')
                node.attribute('href').content = actual_url
            end
        end
    end


    # creates Mechanize::Page::Links because it is easier to parse
    def to_links(html_links)
        links = []

        html_links.each do |link_node|
           links.push Mechanize::Page::Link.new(link_node, nil, nil)
        end

        links
    end

end

# print results
GoogleSearcher.new.search('query').each do |link|
    puts link.text
    puts link.href
    puts
end

