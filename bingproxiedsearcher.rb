require './bingsearcher'

class BingProxiedSearcher < BingSearcher

    private

    def results_page_for(query)
        agent = Mechanize.new
        web_proxy = agent.get('http://pzdl.info/')
        proxy_form = web_proxy.form_with(:action => 'includes/process.php?action=update')
        proxy_form.field_with(:name => 'u').value = query_link query
        proxy_form.checkbox_with(:name => 'encodeURL').checked = false
        agent.submit(proxy_form).parser
    end

    def html_links_from(results_section)
        links = super

        links.each do |link_node|
            href_content = link_node.attribute('href').content

            actual_href = href_content.sub(/^http:\/\/.*=(http.*)&b=./, '\1')
            actual_href = CGI::unescape(actual_href)

            link_node.attribute('href').content = actual_href
        end

        links
    end

end

"""
# print results
#BingProxiedSearcher.new.search_for('query').each do |link|
BingProxiedSearcher.new.test_search.each do |link|
    puts link.text
    puts link.href
    puts
end
"""

