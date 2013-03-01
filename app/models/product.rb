class Product < ActiveRecord::Base
  attr_accessible :price, :product
  monetize :price_cents
end
