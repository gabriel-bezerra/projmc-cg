#!/usr/bin/env ruby

require './searchbot'
require './marshalrepository'

queries = ['google bought motorola',
           'george bush planned 9/11 attacks',
           'when did titanic sink?',
           '"a christmas carol" "charles dickens" books free download',
           'parfum diva by ungaro 50 ml buy',
           'Gunther Jakobs law for the enemy',
           'what is the best chilean wine',
           'how to make shrimp stuffed potatoes',
           'johnson bros england history',
           'manolo blahnik shoes',
           'internet traffic chart web dead',
           'documentary health care united states michael moore',
           'inheritance versus mixins in ruby',
           'web scraping ruby mechanize',
           'how to handle exceptions in java',
           'google web toolkit json rpc',
           'how to extrude a surface in autocad',
           'anonymous attacks visa mastercard wikileaks',
           'sony psn outage 2011',
           'space debris shuttle damage',
           'bin laden dead pictures leaked',
           'marvel avengers movie premiere',
           'khan academy ted talk',
           'richard dawkins the virus of faith',
           'richard dawkins the blind watchmaker']

search_results = SearchBot.new(queries).showtime

repository = MarshalRepository.new 'collected-data'
repository.save search_results

