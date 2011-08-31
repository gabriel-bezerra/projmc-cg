
require 'nokogiri'
require 'mechanize'

f = File.open('search.htm')
doc = Nokogiri::HTML(f)
f.close


results_div = doc.css('div#ires ol')

result_links = []

results_div.css('a.l').each do |link|
    result_links.push link
end



links = []

result_links.each do |link_node|
   links.push Mechanize::Page::Link.new(link_node, nil, nil)
end

puts links.to_s

