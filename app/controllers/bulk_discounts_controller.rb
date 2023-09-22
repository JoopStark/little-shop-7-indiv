class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def create
    bulk_discount = BulkDiscount.create(bulk_discount_params)
    if bulk_discount.save
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
    else
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/new"
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])
    if bulk_discount.update(bulk_discount_params)
      # binding.pry
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/#{params[:id]}"
    else
      # binding.pry
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/#{params[:id]}/edit"
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end


  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
  end

  private

  def bulk_discount_params
    params.permit(:name, :discount, :threshold, :merchant_id)
  end
end