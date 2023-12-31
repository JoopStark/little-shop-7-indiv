require "rails_helper"

RSpec.describe "Admin Merchants" do 
  before :each do 
    load_test_data
  end 

  it "takes you to the merchants show page" do 
    visit admin_merchants_path
    
    click_link("Catbus")
    expect(page).to have_current_path("/admin/merchants/#{@merchant7.id}")
    expect(page).to have_content("Catbus Page")
    expect(page).to_not have_content("Kiki")
  end

  it "can update a merchants information" do 
    visit admin_merchant_path(@merchant7)

    expect(page).to have_link("Update Merchant")
    click_link("Update Merchant")

    expect(page).to have_current_path("/admin/merchants/#{@merchant7.id}/edit")
    
    expect(page).to have_content("Edit Merchant")
    expect(find("form")).to have_content("Name")
    expect(page).to have_button("Submit")
    
    fill_in "Name", with: "Karl"
    click_button "Submit"
    
    expect(page).to have_current_path("/admin/merchants/#{@merchant7.id}")
    expect(page).to have_content("Karl")
    expect(page).to have_content("Information has been successfully updated")
    expect(page).to_not have_content("Catbus")
  end

  it "has a header" do
    load_test_data

    visit admin_merchant_path(@merchant7)

    expect(page).to have_content("Admin: Merchant Section")
  end

end 
