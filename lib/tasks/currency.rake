namespace :currency do
  task :insert => [:environment] do
    require "nokogiri"
    require "open-uri"
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
      if @data[i].css('CrossRateUSD').children.to_s == ""
        cross = 1.to_f/@data[i].css('CrossRateOther').children.to_s.to_f
      else
        cross = @data[i].css('CrossRateUSD').children.to_s
      end
      @currency = {
          :code => @code[i],
          :isim => @data[i].css('Isim').children.to_s,
          :name => @data[i].css('CurrencyName').children.to_s,
          :unit => @data[i].css('Unit').children.to_s,
          :forexbuying => @data[i].css('ForexBuying').children.to_s,
          :forexselling => @data[i].css('ForexSelling').children.to_s,
          :banknotebuying => @data[i].css('BanknoteBuying').children.to_s,
          :banknoteselling => @data[i].css('BanknoteSelling').children.to_s,
          :crossrateusd => cross.to_s,
          :insertiondate => Time.now.to_date
      }
      i += 1
      Currency.create(@currency)
    end
    usd=Currency.find_all_by_code("USD").last
    @currency = {
        :code => "TRY",
        :isim => "Turk Lirasi",
        :name => "Turkish Lira",
        :unit => "1",
        :forexbuying => "1",
        :forexselling => "1",
        :banknotebuying => "1",
        :banknoteselling => "1",
        :crossrateusd => usd.forexbuying.to_s,
        :insertiondate => Time.now.to_date
    }
    Currency.create(@currency)
  end
end
