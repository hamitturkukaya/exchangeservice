class CurrenciesController < ApplicationController
  def index
    if params[:register].present?
      require "nokogiri"
      require "open-uri"
      @doc = Nokogiri::XML(open('http://www.tcmb.gov.tr/kurlar/today.xml'))
      @code = Array.new

      @doc.css("Currency").each do |response_node|
        @code.push(response_node["Kod"])
      end
      @data = @doc.xpath('//Currency')
      @currency = Hash.new
      @array = Array.new
      i=0
      while i<@code.length
        cross =""
        if @data[i].css('CrossRateUSD').text == ""
          cross = @data[i].css('CrossRateOther').text
          mod = (1/cross.to_f).round(4)
          cross = mod.to_s
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
            :crossrateusd => cross,
            :insertiondate => Time.now.to_date
        }
        @array = @array.push(@currency)
        i=i+1
        Currency.create(@currency)
      end
    end
    if params[:from].present? & params[:to].present? & params[:cash].present?
      date = params[:date] || Time.now.to_date
      from = Currency.where(:code => params[:from], :insertiondate => date).last
      to = Currency.where(:code => params[:to], :insertiondate => date).last
      rate = to.crossrateusd.to_f/from.crossrateusd.to_f
      amount = (params[:cash].to_f*rate).round(4)
      @currency = olustur(from,to,params[:cash],amount)
    else
      @currency = {
          :error => "Parameter Error"
      }
    end
    render json: @currency
  end

  def olustur(from, to, cash, amount)
    @currency = {
        :from => from.code,
        :from_name => from.name,
        :to => to.code,
        :to_name => to.name,
        :cash => cash,
        :amount => amount
    }
  end

end
