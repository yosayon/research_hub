class CompanyReport < ActiveRecord::Base
 belongs_to :report
 belongs_to :company
 belongs_to :dimension
 belongs_to :statement
 belongs_to :score
end