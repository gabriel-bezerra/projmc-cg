
require 'nokogiri'
require 'mechanize'

# read results page
def get_results_page
    doc = nil

    File.open('search.htm') do |f|
        doc = Nokogiri::HTML(f)
    end

    doc
end

# get results div from results page
def get_results_div(doc)
    doc.css('div#ires ol')
end

# get links from results div
def get_html_links(results_div)
    result_links = []

    results_div.css('a.l').each do |link|
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


page = get_results_page()
div = get_results_div(page)
html_links = get_html_links(div)
clean_links(html_links)
result_links = to_links(html_links)

# print results
result_links.each do |link|
    puts link.text
    puts link.href
    puts
end
