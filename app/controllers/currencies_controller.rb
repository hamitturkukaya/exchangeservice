class CurrenciesController < ApplicationController
  def index
    if params[:date].present?
      @currency = Currency.find_by_insertiondate(params[:date])
    elsif
      @currency = Currency.find_by_code(params[:code])
    else
      @currency = Currency.all
    end
    render json: @currency
  end
end
