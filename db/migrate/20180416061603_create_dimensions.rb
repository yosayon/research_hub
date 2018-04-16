class CreateDimensions < ActiveRecord::Migration[5.2]
  def change
    create_table :dimensions do |t|
      t.string :name
    end
  end
end
