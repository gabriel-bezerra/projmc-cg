require 'nokogiri'
require 'mechanize'

class Engine

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

end

