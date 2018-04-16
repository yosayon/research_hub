class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.integer :company_id
      t.integer :statement_id
      t.decimal :score
    end
  end
end
