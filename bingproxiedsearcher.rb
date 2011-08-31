require './engine'

class ProxiedEngine < Engine

    def initialize engine
        @engine = engine
    end

    def results_page_for(query)
        agent = Mechanize.new
        web_proxy = agent.get('http://pzdl.info/')
        proxy_form = web_proxy.form_with(:action => 'includes/process.php?action=update')
        proxy_form.field_with(:name => 'u').value = @engine.query_link query
        proxy_form.checkbox_with(:name => 'encodeURL').checked = false
        agent.submit(proxy_form).parser
    end

    def html_links_from(results_section)
        links = @engine.html_links_from results_section

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
require './searcher'
require './bingsearcher'

# print results
Searcher.new(ProxiedEngine.new(BingEngine.new)).search_for('query').each do |link|
#ProxiedSearcher.new(BingSearcher).test_search.each do |link|
    puts link.text
    puts link.href
    puts
end
"""

