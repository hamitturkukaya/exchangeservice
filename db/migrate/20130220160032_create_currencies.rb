class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :code
      t.string :unit
      t.string :isim
      t.string :name
      t.string :forexbuying
      t.string :forexselling
      t.string :banknotebuying
      t.string :banknoteselling
      t.date :insertiondate

      t.timestamps
    end
	add_index :currencies, :code
    add_index :currencies, :insertiondate
  end
end
