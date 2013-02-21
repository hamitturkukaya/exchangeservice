class Currency < ActiveRecord::Base
  attr_accessible :banknotebuying, :banknoteselling, :code, :forexbuying, :forexselling, :insertiondate, :isim, :name, :unit, :crossrateusd
  require "nokogiri"
  require "open-uri"

  def insert
    @doc = Nokogiri::XML(open('http://www.tcmb.gov.tr/kurlar/today.xml'))
    @code = Array.new

    @doc.css("Currency").each do |response_node|
      @code.push(response_node["Kod"])
    end
    @data = @doc.xpath('//Currency')
    @currency = Hash.new
    i=0
    while i<@code.length
      cross =""
      if @data[i].css('CrossRateUSD').text == ""
        cross = 1/@data[i].css('CrossRateOther').to_f
      else
        cross = @data[i].css('CrossRateUSD').text
      end
      @currency = {
          :code => @code[i],
          :isim => @data[i].css('Isim').text,
          :name => @data[i].css('CurrencyName').text,
          :unit => @data[i].css('Unit').text,
          :forexbuying => @data[i].css('ForexBuying').text,
          :forexselling => @data[i].css('ForexSelling').text,
          :banknotebuying => @data[i].css('BanknoteBuying').text,
          :banknoteselling => @data[i].css('BanknoteSelling').text,
          :crossrateusd => cross.text,
          :insertiondate => Time.now.to_date
      }
      i=i+1
      Currency.create(@currency)
    end
  end
end
