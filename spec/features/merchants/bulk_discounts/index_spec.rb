require "rails_helper"

RSpec.describe "Merchant Item Index page" do 
  it "shows a list of discounts with attributes" do
    merchant_1 = Merchant.create!(name: "Kiki")

    dozen = BulkDiscount.create!(name: "Dozen", discount: 0.10, threshold: 12, merchant: merchant_1)
    baker = BulkDiscount.create!(name: "Baker", discount: 0.20, threshold: 13, merchant: merchant_1)
    gross = BulkDiscount.create!(name: "Gross", discount: 0.30, threshold: 144, merchant: merchant_1)

    # visit merchant_bulk_discounts_path(merchant_1)
    visit "/merchants/#{merchant_1.id}/bulk_discounts"

    expect(page).to have_content("Dozen")
    expect(page).to have_content("10")
    expect(page).to have_content("30")
    expect(page).to have_content("12")
    expect(page).to have_content("Baker")
    expect(page).to have_content("Gross")
  end
end