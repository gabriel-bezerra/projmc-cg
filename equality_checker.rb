#!/usr/bin/env ruby
# encoding: utf-8

require "./marshalrepository"

# load collected data

repository = MarshalRepository.new 'collected-data'
search_results_by_query = repository.retrieve

def collect_url_from resultset
    resultset.collect{|result| result.url}
end

def largest_result_list_of lists_of_results
    largest = lists_of_results.first

    lists_of_results.each do |list|
        if list.length > largest.length
            largest = list
        end
    end

    largest
end

# Tests
0.times do
    puts largest_result_list_of([[],[],[]]) == []
    puts largest_result_list_of([['a'],[],[]]) == ['a']
    puts largest_result_list_of([['a'],['a', 'b'],[]]) == ['a', 'b']
end


def smallest_result_list_of lists_of_results
    smallest = lists_of_results.first

    lists_of_results.each do |list|
        if list.length < smallest.length
            smallest = list
        end
    end

    smallest
end

# Tests
0.times do
    puts smallest_result_list_of([[],[],[]]) == []
    puts smallest_result_list_of([['a'],[],[]]) == []
    puts smallest_result_list_of([['a'],['a', 'b'],[]]) == []
end

def reduced_copy_of array, to_size
    copy = array[0, to_size]
    copy
end


#Equality ratio with ranking (base)---------------------------------------------

def number_of_equal_results_with_ranking_between resultset1, resultset2
    largest_resultset = largest_result_list_of [resultset1, resultset2]
    smallest_resultset = smallest_result_list_of [resultset1, resultset2]

    #adjusted_resultset != smallest_resultset
    adjusted_resultset = (smallest_resultset == resultset1) ? resultset2 : resultset1
    adjusted_resultset = reduced_copy_of adjusted_resultset, smallest_resultset.size

    number_of_equal_results = 0
    smallest_resultset.each_with_index do |result, index|
        if result.url == adjusted_resultset[index].url
            number_of_equal_results += 1
        end
    end

    number_of_equal_results
end

def equality_ratio_for_same_ranking_between first_result_list, second_result_list
    number_of_equal_results = number_of_equal_results_with_ranking_between first_result_list, second_result_list

    smallest_result_list = smallest_result_list_of [first_result_list, second_result_list]

    (1.0 * number_of_equal_results) / smallest_result_list.length
end

#Equality ratio with ranking (test)---------------------------------------------

0.times do
    compared_engines = [:bing, :yahoo]

    search_results_by_query.each do |query, engines|
        engine1s_results = compared_engines.first
        engine2s_results = compared_engines.last

        equality_ratio = equality_ratio_for_same_ranking_between engine1s_results, engine2s_results

        puts equality_ratio.to_s + ' ' + query
    end
end


#Equality ratio with ranking (charts)---------------------------------------------

1.times do
    require "rinruby"

    queries = search_results_by_query.keys
    result_counts = search_results_by_query.values

    R.queries = queries.collect {|query| queries.index(query) + 1}
    R.result_counts1 = result_counts.collect {|results| equality_ratio_for_same_ranking_between results[:google], results[:bing]}
    R.result_counts2 = result_counts.collect {|results| equality_ratio_for_same_ranking_between results[:google], results[:yahoo]}
    R.result_counts3 = result_counts.collect {|results| equality_ratio_for_same_ranking_between results[:yahoo], results[:bing]}

    R.eval <<EOF
        png("er_with_rank_google_bing.png", width=900)
        names(result_counts1) <- queries
        barplot(result_counts1,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Proporção de resultados iguais",
                main="Proporção de resultados iguais no mesmo rank por consulta entre Google e Bing")
EOF

    R.eval <<EOF
        png("er_with_rank_google_yahoo.png", width=900)
        names(result_counts2) <- queries
        barplot(result_counts2,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Proporção de resultados iguais",
                main="Proporção de resultados iguais no mesmo rank por consulta entre Google e Yahoo")
EOF

    R.eval <<EOF
        png("er_with_rank_yahoo_bing.png", width=900)
        names(result_counts3) <- queries
        barplot(result_counts3,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Proporção de resultados iguais",
                main="Proporção de resultados iguais no mesmo rank por consulta entre Yahoo e Bing")
EOF
end

#Equality ratio without ranking (base)------------------------------------------

def number_of_equal_results_without_ranking_of resultset1, resultset2
    urls1 = collect_url_from resultset1
    urls2 = collect_url_from resultset2
    equality = urls1 & urls2
    number_of_equal_results = equality.length
    number_of_equal_results
end

def equality_ratio_without_ranking_of resultset1, resultset2
    smallest_resultset = smallest_result_list_of [resultset1, resultset2]
    largest_resultset = largest_result_list_of [resultset1, resultset2]

    adjusted_resultset = (smallest_resultset == resultset1) ? resultset2 : resultset1
    adjusted_resultset = reduced_copy_of adjusted_resultset, smallest_resultset.size

    number_of_equal_results = number_of_equal_results_without_ranking_of smallest_resultset, adjusted_resultset

    equality_ratio = (1.0 * number_of_equal_results) / smallest_resultset.size
    equality_ratio
end

#Equality ratio without ranking (test)------------------------------------------

0.times do
    puts 'Comparing without ranking--------------------------------------------'

    compared_engines = [:bing, :yahoo]

    search_results_by_query.each do |query, engines|
        engine1s_results = engines[compared_engines.first]
        engine2s_results = engines[compared_engines.last]
        number_of_equal_results = number_of_equal_results_without_ranking_of engine1s_results, engine2s_results
        equality_ratio = equality_ratio_without_ranking_of engine1s_results, engine2s_results

        puts 'engine1s_results.length:' + engine1s_results.length.to_s
        puts 'engine2s_results.length:' + engine2s_results.length.to_s
        puts 'number_of_equal_results:' + number_of_equal_results.to_s
        puts query
        puts equality_ratio
        puts
    end
end

#Equality ratio without ranking (charts)----------------------------------------

1.times do
    require "rinruby"

    queries = search_results_by_query.keys
    result_counts = search_results_by_query.values

    R.queries = queries.collect {|query| queries.index(query) + 1}
    R.result_counts1 = result_counts.collect {|results| equality_ratio_without_ranking_of results[:google], results[:bing]}
    R.result_counts2 = result_counts.collect {|results| equality_ratio_without_ranking_of results[:google], results[:yahoo]}
    R.result_counts3 = result_counts.collect {|results| equality_ratio_without_ranking_of results[:yahoo], results[:bing]}

    R.eval <<EOF
        png("er_without_rank_google_bing.png", width=900)
        names(result_counts1) <- queries
        barplot(result_counts1,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Proporção de resultados iguais",
                main="Proporção de resultados iguais por consulta entre Google e Bing")
EOF

    R.eval <<EOF
        png("er_without_rank_google_yahoo.png", width=900)
        names(result_counts2) <- queries
        barplot(result_counts2,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Proporção de resultados iguais",
                main="Proporção de resultados iguais por consulta entre Google e Yahoo")
EOF

    R.eval <<EOF
        png("er_without_rank_yahoo_bing.png", width=900)
        names(result_counts3) <- queries
        barplot(result_counts3,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Proporção de resultados iguais",
                main="Proporção de resultados iguais por consulta entre Yahoo e Bing")
EOF
end


# Ranking similarity

def order_of_results_in_result_list result_list, result0, result1
    (result_list.index(result0) > result_list.index(result1)) ? :desc
                                                              : :asc
end

def number_of_equal_orderings_between_common_pairs_of result_list0, result_list1
    common_results = result_list0 & result_list1
    number_of_equal_orderings = 0

    common_results.combination(2) do |result0, result1|
        order_in_first_resultsset = order_of_results_in_result_list result_list0, result0, result1
        order_in_second_resultsset = order_of_results_in_result_list result_list1, result0, result1

        number_of_equal_orderings += 1 if order_in_first_resultsset == order_in_second_resultsset
    end

    number_of_equal_orderings
end

def number_of_distinct_pairs_of_elements_of list
    # combination(length, 2)
    list.length * (list.length - 1) / 2
end

def ordering_equality_ratio_between result_list0, result_list1
    common_results = result_list0 & result_list1

    number_of_common_pairs = number_of_distinct_pairs_of_elements_of common_results
    number_of_equal_orderings = number_of_equal_orderings_between_common_pairs_of result_list0, result_list1

    Float(number_of_equal_orderings) / number_of_common_pairs
end

def equality_ratio_considering_results_ordering_between_results result_list0, result_list1
    common_results = result_list0 & result_list1

    number_of_common_pairs = number_of_distinct_pairs_of_elements_of common_results

    ordering_equality_ratio = ordering_equality_ratio_between result_list0, result_list1

    number_of_pairs0 = number_of_distinct_pairs_of_elements_of result_list0
    number_of_pairs1 = number_of_distinct_pairs_of_elements_of result_list1
    number_of_pairs_of_the_union_of_0_and_1 = (number_of_pairs0 + number_of_pairs1 - number_of_common_pairs)

    engines_equality_ratio = Float(number_of_common_pairs) / number_of_pairs_of_the_union_of_0_and_1

    ordering_equality_ratio * engines_equality_ratio
end

#Testing
0.times do
    puts 'Test comparing considering results ordering --------------------------------------------'

    first_list = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']
    second_list = ['j', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']

    #first_list = ['a', 'b', 'c']
    #second_list = ['c', 'b', 'a']

    #first_list = ['a', 'b', 'c', 'd']
    #second_list = ['c', 'a', 'b', 'd']

    query_equality_ratio = equality_ratio_considering_results_ordering_between_results first_list, second_list
    puts "#{first_list}-#{second_list} equality ratio = #{query_equality_ratio}"
end

def equality_ratio_considering_results_ordering_between full_result_list0, full_result_list1
    smallest_full_result_list = smallest_result_list_of [full_result_list0, full_result_list1]
    largest_full_result_list = largest_result_list_of [full_result_list0, full_result_list1]

    adjusted_full_result_list = (smallest_full_result_list == full_result_list0) ? full_result_list1
                                                                                 : full_result_list0
    adjusted_full_result_list = reduced_copy_of adjusted_full_result_list, smallest_full_result_list.size

    result_list0 = collect_url_from smallest_full_result_list
    result_list1 = collect_url_from adjusted_full_result_list

    equality_ratio_considering_results_ordering_between_results result_list0, result_list1
end

0.times do
    puts 'Comparing considering results ordering --------------------------------------------'

    compared_engines = [:bing, :yahoo]

    search_results_by_query.each do |query, engines|
        first_engine = compared_engines.first
        second_engine = compared_engines.last

        query_equality_ratio = equality_ratio_considering_results_ordering_between engines[first_engine], engines[second_engine]
        puts "query_equality_ratio = #{query_equality_ratio}"
    end
end

#Equality ratio considering results ordering (charts)----------------------------------------

1.times do
    require "rinruby"

    queries = search_results_by_query.keys
    result_counts = search_results_by_query.values

    R.queries = queries.collect {|query| queries.index(query) + 1}
    R.result_counts1 = result_counts.collect {|results| equality_ratio_considering_results_ordering_between results[:google], results[:bing]}
    R.result_counts2 = result_counts.collect {|results| equality_ratio_considering_results_ordering_between results[:google], results[:yahoo]}
    R.result_counts3 = result_counts.collect {|results| equality_ratio_considering_results_ordering_between results[:yahoo], results[:bing]}

    R.eval <<EOF
        png("er_rank_order_google_bing.png", width=900)
        names(result_counts1) <- queries
        barplot(result_counts1,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Probabilidade de se obter resultados iguais com mesma ordenação",
                main="Probabilidade de se obter resultados iguais com mesma ordenação por consulta entre Google e Bing")
EOF

    R.eval <<EOF
        png("er_rank_order_google_yahoo.png", width=900)
        names(result_counts2) <- queries
        barplot(result_counts2,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Probabilidade de se obter resultados iguais com mesma ordenação",
                main="Probabilidade de se obter resultados iguais com mesma ordenação por consulta entre Google e Yahoo")
EOF

    R.eval <<EOF
        png("er_rank_order_yahoo_bing.png", width=900)
        names(result_counts3) <- queries
        barplot(result_counts3,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="Probabilidade de se obter resultados iguais com mesma ordenação",
                main="Probabilidade de se obter resultados iguais com mesma ordenação por consulta entre Yahoo e Bing")
EOF
end

# Ordering equality ratio

def ordering_equality_ratio_for_full_results_between full_result_list0, full_result_list1
    smallest_full_result_list = smallest_result_list_of [full_result_list0, full_result_list1]
    largest_full_result_list = largest_result_list_of [full_result_list0, full_result_list1]

    adjusted_full_result_list = (smallest_full_result_list == full_result_list0) ? full_result_list1
                                                                                 : full_result_list0
    adjusted_full_result_list = reduced_copy_of adjusted_full_result_list, smallest_full_result_list.size

    result_list0 = collect_url_from smallest_full_result_list
    result_list1 = collect_url_from adjusted_full_result_list

    ordering_equality_ratio_between result_list0, result_list1
end

0.times do
    puts ' ordering equality ratio --------------------------------------------'

    compared_engines = [:bing, :yahoo]

    search_results_by_query.each do |query, engines|
        first_engine = compared_engines.first
        second_engine = compared_engines.last

        ordering_equality_ratio = ordering_equality_ratio_for_full_results_between engines[first_engine], engines[second_engine]
        puts "ordering_equality_ratio = #{ordering_equality_ratio}"
    end
end

# Ordering equality ratio (charts)----------------------------------------

1.times do
    require "rinruby"

    queries = search_results_by_query.keys
    result_counts = search_results_by_query.values

    file_prefix = "er_ordering"
    y_label = "Proporção dos resultados em comum com a mesma ordenação"
    main_label = "#{y_label} por consulta"

    R.queries = queries.collect {|query| queries.index(query) + 1}
    R.result_counts1 = result_counts.collect {|results| ordering_equality_ratio_for_full_results_between results[:google], results[:bing]}
    R.result_counts2 = result_counts.collect {|results| ordering_equality_ratio_for_full_results_between results[:google], results[:yahoo]}
    R.result_counts3 = result_counts.collect {|results| ordering_equality_ratio_for_full_results_between results[:yahoo], results[:bing]}

    R.eval <<EOF
        png("#{file_prefix}_google_bing.png", width=900)
        names(result_counts1) <- queries
        barplot(result_counts1,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="#{y_label}",
                main="#{main_label} entre Google e Bing")
EOF

    R.eval <<EOF
        png("#{file_prefix}_google_yahoo.png", width=900)
        names(result_counts2) <- queries
        barplot(result_counts2,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="#{y_label}",
                main="#{main_label} entre Google e Yahoo")
EOF

    R.eval <<EOF
        png("#{file_prefix}_yahoo_bing.png", width=900)
        names(result_counts3) <- queries
        barplot(result_counts3,
                las=1,
                col="lightgreen",
                xlab="Consultas",
                ylab="#{y_label}",
                main="#{main_label} entre Yahoo e Bing")
EOF
end


# Hypothesis test

# equal sets of results

def equality_vector_for engine0, engine1, search_results
    coincidence_vector = []

    search_results.values.map do |engines|
        resultset1 = collect_url_from engines[engine0]
        resultset2 = collect_url_from engines[engine1]

        smallest_resultset = smallest_result_list_of [resultset1, resultset2]
        largest_resultset = largest_result_list_of [resultset1, resultset2]

        adjusted_resultset = (smallest_resultset == resultset1) ? resultset2 : resultset1
        adjusted_resultset = reduced_copy_of adjusted_resultset, smallest_resultset.size

        smallest_resultset.each do |result|
            coincidence_vector << ((adjusted_resultset.include? result) ? 1 : 0)
        end
    end

    coincidence_vector
end

1.times do
    R.equality_vector1 = equality_vector_for(:google, :bing, search_results_by_query)
    R.equality_vector2 = equality_vector_for(:google, :yahoo, search_results_by_query)
    R.equality_vector3 = equality_vector_for(:yahoo, :bing, search_results_by_query)

    R.eval <<EOF
        t.test(equality_vector1, mu=0.95, alternative="less")
        t.test(equality_vector2, mu=0.95, alternative="less")
        t.test(equality_vector3, mu=0.95, alternative="less")
EOF
end


# equal ordering of common results

def ordering_vector_for engine0, engine1, search_results
    coincidence_vector = []

    search_results.values.map do |engines|
        resultset1 = collect_url_from engines[engine0]
        resultset2 = collect_url_from engines[engine1]

        smallest_resultset = smallest_result_list_of [resultset1, resultset2]
        largest_resultset = largest_result_list_of [resultset1, resultset2]

        adjusted_resultset = (smallest_resultset == resultset1) ? resultset2 : resultset1
        adjusted_resultset = reduced_copy_of adjusted_resultset, smallest_resultset.size

        result_list0 = smallest_resultset
        result_list1 = adjusted_resultset

        common_results = result_list0 & result_list1
        number_of_common_pairs = number_of_distinct_pairs_of_elements_of common_results

        if (number_of_common_pairs > 0)
            number_of_equal_orderings = number_of_equal_orderings_between_common_pairs_of result_list0, result_list1

            number_of_equal_orderings.times do
                coincidence_vector << 1
            end

            (number_of_common_pairs - number_of_equal_orderings).times do
                coincidence_vector << 0
            end
        end
    end

    coincidence_vector
end

1.times do
    R.ordering_vector1 = ordering_vector_for(:google, :bing, search_results_by_query)
    R.ordering_vector2 = ordering_vector_for(:google, :yahoo, search_results_by_query)
    R.ordering_vector3 = ordering_vector_for(:yahoo, :bing, search_results_by_query)

    R.eval <<EOF
        t.test(ordering_vector1, mu=0.95, alternative="less")
        t.test(ordering_vector2, mu=0.95, alternative="less")
        t.test(ordering_vector3, mu=0.95, alternative="less")
EOF
end

