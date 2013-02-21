class CurrenciesController < ApplicationController
  def index
    #if params[:register].present?
    #  require "nokogiri"
    #  require "open-uri"
    #    @doc = Nokogiri::XML(open('http://www.tcmb.gov.tr/kurlar/today.xml'))
    #    @code = Array.new
    #
    #    @doc.css("Currency").each do |response_node|
    #      @code.push(response_node["Kod"])
    #    end
    #    @data = @doc.xpath('//Currency')
    #    @currency = Hash.new
    #    @array = Array.new
    #    i=0
    #    while i<@code.length
    #      cross =""
    #      if @data[i].css('CrossRateUSD').text == ""
    #        cross = @data[i].css('CrossRateOther').text
    #        mod = (1/cross.to_f).round(4)
    #        cross = mod.to_s
    #      else
    #        cross = @data[i].css('CrossRateUSD').text
    #      end
    #      @currency = {
    #          :code => @code[i],
    #          :isim => @data[i].css('Isim').text,
    #          :name => @data[i].css('CurrencyName').text,
    #          :unit => @data[i].css('Unit').text,
    #          :forexbuying => @data[i].css('ForexBuying').text,
    #          :forexselling => @data[i].css('ForexSelling').text,
    #          :banknotebuying => @data[i].css('BanknoteBuying').text,
    #          :banknoteselling => @data[i].css('BanknoteSelling').text,
    #          :crossrateusd => cross,
    #          :insertiondate => Time.now.to_date
    #      }
    #      @array = @array.push(@currency)
    #      i=i+1
    #      Currency.create(@currency)
    #    end
    #end
    if params[:date].present? and  params[:code].present?

      @currency = Currency.where(:currencies => {:code => params[:code], :insertiondate => params[:date]})

    elsif params[:from].present?  and params[:to].present? and params[:cash].present?
      from = Currency.find_by_code(params[:from]).crossrateusd.to_f
      to =  Currency.find_by_code(params[:to]).crossrateusd.to_f
      @currency =  {
                      :from   => params[:from],
                      :to     => params[:to],
                      :cash   => params[:cash],
                      :amount => (params[:cash].to_f*to/from).round(4)
      }
    elsif params[:from].present?  and params[:cash].present?
      from = Currency.find_by_code(params[:from])
      from_rate = from.crossrateusd.to_f
      to=Currency.all
      tl_rate=  1/from.forexbuying.to_f
      @currency = Array.new
      @hash =  {
          :from   => params[:from],
          :to     => "TRY",
          :cash   => params[:cash],
          :amount => (params[:cash].to_f/tl_rate).round(4)
      }
      @currency.push(@hash)
      for item in to
        if item.crossrateusd != ""
          @hash =  {
              :from   => params[:from],
              :to     => item.code,
              :cash   => params[:cash],
              :amount => (params[:cash].to_f*item.crossrateusd.to_f/from_rate).round(4)
          }
          @currency.push(@hash)
        end

      end

    elsif params[:date].present?
      @currency = Currency.find_all_by_insertiondate(params[:date])
    elsif params[:code].present?
      @currency = Currency.find_all_by_code(params[:code])
    else
      @currency = Currency.all
    end
    render json: @currency
  end
end
