#!usr/bin/env ruby

require 'rubygems'
require 'mechanize'

require './googlesearcher'
require './yahoosearcher'

# A basic searcher
class Searcher
    def initialize(home, form_name, query_field_name)
        @home = home
        @query_field_name = query_field_name

        @agent = Mechanize.new
        @form = @agent.get(@home).form(form_name)
    end

    def search(query)
        @form.send(@query_field_name, query)
        @agent.submit(@form, @form.buttons.first)
    end
end

# A Bing searcher
class Bing < Searcher
    def initialize
        super('http://www.bing.com', 'nil', 'q')
        @form = @agent.get(@home).forms.first
    end
end

#Testing-----------------------------------------------------------------------

def show_these_links(links)
    links.each do |link|
        puts link.text
        puts link.href
        puts
    end
end

query = 'inheritance in ruby'

puts 'GOOGLE------------------------------------------------------------------'
r1 = GoogleSearcher.new.search_for(query)
show_these_links(r1)

puts 'YAHOO!------------------------------------------------------------------'
r2 = YahooSearcher.new.search_for(query)
show_these_links(r2)

puts 'BING--------------------------------------------------------------------'
r3 = Bing.new.search(query)
r3.links.each do |link|
    puts link.text
end
