require 'zip_api'

class QueriesController < ApplicationController

  def show
    @query = Query.find(params[:id])
    api = ZipAPI.new
    pp api.dollar_sales(@query.zip1).first["dollar_homes"].to_i
    pp api.dollar_sales(@query.zip2).first["dollar_homes"].to_i
  end

  def new
    @query = Query.new
  end

  def create
    @query = Query.new(query_params)
    if @query.save
      redirect_to query_path(@query)
    else
      flash.now[:danger] = "Please try again."
      render :new
    end
  end

  def edit
  end

  def update
  end

  private

  def query_params
    params.require(:query).permit(:zip1, :zip2)
  end

end
