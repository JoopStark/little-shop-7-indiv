require "rails_helper"

RSpec.describe "Merchant Item Index page" do 
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Kiki")
    @merchant_2 = Merchant.create!(name: "Dave")

    BulkDiscount.create!(name: "Dozen", discount: 0.10, threshold: 12, merchant: @merchant_1)
    BulkDiscount.create!(name: "Baker", discount: 0.20, threshold: 13, merchant: @merchant_1)
    BulkDiscount.create!(name: "Gross", discount: 0.30, threshold: 144, merchant: @merchant_1)
    BulkDiscount.create!(name: "Nope", discount: 0.99, threshold: 999, merchant: @merchant_2)
  end

  it "shows a list of discounts with attributes" do

    visit merchant_bulk_discounts_path(@merchant_1)

    expect(page).to have_content("Dozen")
    expect(page).to have_content("10")
    expect(page).to have_content("30")
    expect(page).to have_content("12")
    expect(page).to have_content("Baker")
    expect(page).to have_content("Gross")
    expect(page).to_not have_content("Nope")
  end

  it "has a link to create a new discount" do
    visit merchant_bulk_discounts_path(@merchant_1)

    expect(page).to have_link('Create New Discount')

    click_link 'Create New Discount'

    expect(page).to have_current_path(new_merchant_bulk_discount_path(@merchant_1))
  end
end