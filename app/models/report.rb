class Report < ActiveRecord::Base
 belongs_to :user
 has_many :company_reports
 has_many :companies, through: :company_reports
 has_many :dimensions, through: :company_reports
 has_many :statements, through: :company_reports
 has_many :scores, through: :company_reports
end