class CreateStatements < ActiveRecord::Migration[5.2]
  def change
    create_table :statemnts do |t|
      t.string :name
      t.integer :dimension_id
    end
  end
end
