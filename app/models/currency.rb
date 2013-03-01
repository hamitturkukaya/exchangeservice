class Currency < ActiveRecord::Base
  attr_accessible :banknotebuying, :banknoteselling, :code, :forexbuying, :forexselling, :insertiondate, :isim, :name, :unit, :crossrateusd
end
