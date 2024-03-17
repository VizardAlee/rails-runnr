class CreateAdminProductStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :product_stocks do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :size
      t.integer :quantity

      t.timestamps
    end
  end
end
