class AddCrossRateUsdToCurrencies < ActiveRecord::Migration
  def change
    add_column :currencies, :crossrateusd, :string
  end
end
