require "rails_helper"

RSpec.describe "new bulk discount page" do
  before (:each) do
    @merchant_1 = Merchant.create!(name: "Kiki")
    @dozen = BulkDiscount.create!(name: "Dozen", discount: 0.10, threshold: 12, merchant: @merchant_1)
  end

  it "it can edit a discount when form fully completed" do
    visit merchant_bulk_discount_path(@merchant_1, @dozen)

    expect(page).to have_content("Dozen")
    expect(page).to have_content("10.0%")
    expect(page).to have_content("12")

    click_button "Edit Discount"

    have_field('Name', with: 'Dozen')
    have_field('Discount (as decimal)', with: '0.1')
    have_field('Threshold', with: '12')

    fill_in "Name", with: "Seasonal"

    click_button "Add Bulk Discount"

    expect(page).to have_current_path(merchant_bulk_discount_path(@merchant_1, @dozen))
    expect(page).to have_content("Seasonal")
    expect(page).to have_content("10.0%")
    expect(page).to have_content("12")
  end

  it "it cannot edit a discount when form incomplete completed" do
    visit merchant_bulk_discount_path(@merchant_1, @dozen)

    expect(page).to have_content("Dozen")
    expect(page).to have_content("10.0%")
    expect(page).to have_content("12")

    click_button "Edit Discount"

    fill_in "Name", with: nil


    click_button "Add Bulk Discount"

    expect(page).to have_content("Error: Name can't be blank")
    have_field('Name', with: 'Dozen')
    have_field('Discount (as decimal)', with: '0.1')
    have_field('Threshold', with: '12')
  end

  it "it cannot edit a discount when discount fraction is out of range" do
    visit merchant_bulk_discount_path(@merchant_1, @dozen)

    expect(page).to have_content("Dozen")
    expect(page).to have_content("10.0%")
    expect(page).to have_content("12")

    click_button "Edit Discount"

    fill_in "Discount", with: 10


    click_button "Add Bulk Discount"
    
    expect(page).to have_content("Error: Discount must be less than 1")
    have_field('Name', with: 'Dozen')
    have_field('Discount (as decimal)', with: '0.1')
    have_field('Threshold', with: '12')
  end

  it "it cannot edit a discount when threshold is out of range" do
    visit merchant_bulk_discount_path(@merchant_1, @dozen)

    expect(page).to have_content("Dozen")
    expect(page).to have_content("10.0%")
    expect(page).to have_content("12")

    click_button "Edit Discount"

    fill_in "Threshold", with: -10

    click_button "Add Bulk Discount"
    
    expect(page).to have_content("Error: Threshold must be greater than 0")
    have_field('Name', with: 'Dozen')
    have_field('Discount (as decimal)', with: '0.1')
    have_field('Threshold', with: '12')
  end
end
