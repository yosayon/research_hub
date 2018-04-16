require 'csv'

#seed companies
companies = CSV.read('./db/data/companies.csv')
companies_array = []
companies.each{|row|companies_array << {:name => row[0], :response_count => row[1], :credibility_average => row[2], :respect_average => row[3], :fairness_average => row[4], :pride_average => row[5], :camaraderie_average => row[6], :final_statement => row[7], :average => row[8]}}
companies_array.each{|hash|Company.create(hash)}

#see dimensions
dimensions = CSV.read('./db/data/dimensions.csv')
dimensions_array = []
dimensions.each{|row|dimensions_array << {:name => row[0]}}
dimensions_array.each{|hash|Dimension.create(hash)}

#seed statements and its dimension ID
statements = CSV.read('./db/data/statements.csv')
statements_array = []
statements.each{|row|statements_array << {:name => row[0], :dimension_id => row[1]}}
statements_array.each{|hash|Statement.create(hash)}

#seed scores
scores = CSV.read('./db/data/scores.csv')
scores_array = []
scores.each{|row|scores_array << {:company_id => row[0], :statement_id => row[1], :score => row[2]}}
scores_array.each{|hash|Score.create(hash)}
