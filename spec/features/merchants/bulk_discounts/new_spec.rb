require "rails_helper"

RSpec.describe "new bulk discount page" do
  before (:each) do
    @merchant_1 = Merchant.create!(name: "Kiki")
  end

  it "it creates a new bulk discount when fully completed" do
    visit new_merchant_bulk_discount_path(@merchant_1)

    fill_in "Name", with: "Seasonal"
    fill_in "Discount (as decimal)", with: 0.255
    fill_in "Threshold", with: 50

    click_button "Add Bulk Discount"

    expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant_1))
    expect(page).to have_content("Seasonal")
    expect(page).to have_content("25.5%")
    expect(page).to have_content("50")
  end

  it "it creates a new bulk discount when fully completed" do
    visit new_merchant_bulk_discount_path(@merchant_1)

    fill_in "Name", with: "Seasonal"
    fill_in "Threshold", with: 50

    click_button "Add Bulk Discount"
    
    expect(page).to have_current_path("/merchants/#{@merchant_1.id}/bulk_discounts/new")
    expect(page).to have_content("Error")
  end

  it "Discount must be a number under 1" do
    visit new_merchant_bulk_discount_path(@merchant_1)

    fill_in "Name", with: "Seasonal"
    fill_in "Discount (as decimal)", with: 1.5
    fill_in "Threshold", with: 50

    click_button "Add Bulk Discount"
   
    expect(page).to have_current_path("/merchants/#{@merchant_1.id}/bulk_discounts/new")
    expect(page).to have_content("Error: Discount must be less than 1")
  end

  it "Discount must be a number greater than 0" do
    visit new_merchant_bulk_discount_path(@merchant_1)

    fill_in "Name", with: "Seasonal"
    fill_in "Discount (as decimal)", with: -0.5
    fill_in "Threshold", with: 50

    click_button "Add Bulk Discount"

    expect(page).to have_current_path("/merchants/#{@merchant_1.id}/bulk_discounts/new")
    expect(page).to have_content("Discount must be greater than 0")
  end
end
    