#!usr/bin/env ruby

require 'rubygems'
require 'mechanize'

# A base searcher
class Searcher
    def initialize(home, form_name, query_field_name)
        @home = home
        @agent = Mechanize.new
	@form = @agent.get(@home).form(form_name)
        @query_field_name = query_field_name
    end
    def search(query)
	@form.send(@query_field_name, query)
	@agent.submit(@form, @form.buttons.first)
    end
end

# A Google searcher
class Google < Searcher
    def initialize
        super('http://www.google.com', 'f', 'q')
    end
end

# A Yahoo! searcher
class Yahoo < Searcher
    def initialize
        super('http://www.yahoo.com', 'sf1', 'p')
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

query = 'inheritance in ruby'

puts 'GOOGLE------------------------------------------------------------------'
r1 = Google.new.search(query)
r1.links.each do |link|
    puts link.text
end
puts 'YAHOO!------------------------------------------------------------------'
r2 = Yahoo.new.search(query)
r2.links.each do |link|
    puts link.text
end
puts 'BING--------------------------------------------------------------------'
r3 = Bing.new.search(query)
r3.links.each do |link|
    puts link.text
end
