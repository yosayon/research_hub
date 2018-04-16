class CreateCompanyReports < ActiveRecord::Migration[5.2]
  def change
    create_table :company_reports do |t|
      t.integer :report_id
      t.integer :company_id
      t.integer :dimension_id
      t.integer :statement_id
      t.integer :score_id
    end
  end
end
