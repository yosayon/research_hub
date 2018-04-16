class FixStatementTableName < ActiveRecord::Migration[5.2]
  def change
    rename_table :statemnts, :statements
  end
end
