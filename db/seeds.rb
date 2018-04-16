require 'csv'

#seed companies
companies = CSV.read('./db/data/companies.csv')
companies_array = []
companies.each{|row|companies_array << {:name => row[0]}}
companies_array.each{|hash|Company.create(hash)}

#seed dimensions
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

#seed company_reports
company_reports = CSV.read('./db/data/company_reports.csv')
company_reports_array = []
company_reports.each{|row|company_reports_array << {:company_id => row[1], :statement_id => row[2], :score_id => row[3], :dimension_id => row[4]}}
company_reports_array.each{|hash|CompanyReport.create(hash)}
