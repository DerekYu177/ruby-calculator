#!/usr/bin/ruby

TEST = "((104+4)*5)+65+6*5+(48+234)"
t = TEST.scan(/\d+[\+\-\*\/]\d+/) #-> ["104+4", "65+6"]

test = TEST
t.each { |match|
	m_sym_location = match =~ /[\+\-\*\/]/
	puts " #{match}, location of symbol is: #{m_sym_location} "
	sym = match.match(/[\+\-\*\/]/)
	exp_location = test =~ /#{Regexp.escape(match)}/
	puts " #{test}, location of expression is: #{exp_location}"
	sub_location = m_sym_location + exp_location
	puts " putting it all together, the location of the symbol \"#{sym}\" is #{sub_location}"
	test[sub_location] = " "
	puts " doing the removal, we get #{test}"
	puts "\n"
}

f = test.scan(/\d+[\+\-\*\/]\d+/)
puts " finally, we have #{f} as well"

f.each { |new_exp|
	t << new_exp
}

puts " together, we have #{t}" 