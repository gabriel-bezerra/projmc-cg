
require 'nokogiri'
require 'mechanize'

# read results page
doc = nil

File.open('search.htm') do |f|
    doc = Nokogiri::HTML(f)
end


# get results div from results page
results_div = doc.css('div#ires ol')

# get links from results div
result_links = []

results_div.css('a.l').each do |link|
    result_links.push link
end


# links must start with http://
result_links.each do |node|
    unless /^http:\/\// =~ node.attribute('href')
        actual_url = node.attribute('href').content.sub(/^.*http:\/\//, 'http://')
        node.attribute('href').content = actual_url
    end
end


# creates Mechanize::Page::Links because it is easier to parse
links = []

result_links.each do |link_node|
   links.push Mechanize::Page::Link.new(link_node, nil, nil)
end


# print results
links.each do |link|
    puts link.text
    puts link.href
    puts
end
