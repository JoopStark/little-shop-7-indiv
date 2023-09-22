require "rails_helper"

RSpec.describe "Merchant Item Show page" do 
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Kiki")
    @merchant_2 = Merchant.create!(name: "Dave")

    @dozen = BulkDiscount.create!(name: "Dozen", discount: 0.10, threshold: 12, merchant: @merchant_1)
    @baker = BulkDiscount.create!(name: "Baker", discount: 0.20, threshold: 13, merchant: @merchant_1)
    BulkDiscount.create!(name: "Gross", discount: 0.30, threshold: 144, merchant: @merchant_1)
    BulkDiscount.create!(name: "Nope", discount: 0.99, threshold: 999, merchant: @merchant_2)
  end

  it "has a discount with attributes" do
    visit merchant_bulk_discount_path(@merchant_1, @dozen)
    
    expect(page).to have_content("Dozen")
    expect(page).to have_content("10.0%")
    expect(page).to have_content("12")
    expect(page).to have_button("Edit Discount")
  end
  
  it "has a discount with attributes" do
    visit merchant_bulk_discount_path(@merchant_1, @dozen)

    expect(page).to have_button("Edit Discount")

    click_button "Edit Discount"

    expect(page).to have_current_path("/merchants/#{@dozen.merchant.id}/bulk_discounts/#{@dozen.id}/edit")
  end
end