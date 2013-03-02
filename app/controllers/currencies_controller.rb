class CurrenciesController < ApplicationController
  def index
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
