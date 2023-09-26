require "rails_helper"

RSpec.describe "Merchant Invoice Show page" do 
  before(:each) do 
    load_test_data
  end
  it "shows a list of all my items" do 
    visit "merchants/#{@merchant1.id}/invoices/#{@invoice_1.id}"
    # binding.pry

    within "#single_invoice" do 
       expect(page).to have_content(@invoice_1.id)
       expect(page).to have_content(@invoice_1.status.capitalize)
       expect(page).to have_content(@invoice_1.customer.first_name)
       expect(page).to have_content(@invoice_1.customer.last_name)
    end
  end

  it "shows its items and details" do 
    load_test_data

    visit "merchants/#{@merchant1.id}/invoices/#{@invoice_1.id}"
    invoice_item = @invoice_1.invoice_items.first

    within "#invoice_items" do 
      expect(page).to have_content(invoice_item.item.name)
       expect(page).to have_content(invoice_item.quantity)
       expect(page).to have_content("$4.00")
       expect(page).to have_content(invoice_item.status)
    end
  end

  it "can calculate the total_revenue for Merchant Invoices show page" do
    load_test_data

    visit "merchants/#{@merchant1.id}/invoices/#{@invoice_1.id}"

    expect(find("#total_revenue")).to have_content("$52.00")

  end

  it "can change the status of the merchant invoice item" do
    load_test_data

    visit "merchants/#{@merchant1.id}/invoices/#{@invoice_1.id}"
    
    expect(page).to have_field('status', with: 'packaged')
    expect(page).to_not have_field('status', with: 'shipped')
    
    select('shipped', from: 'status')
    click_button "Update Item Status"

    expect(page).to_not have_field('status', with: 'pending')
    expect(page).to have_field('status', with: 'shipped')
  end

  it "can new discounted price" do
    load_best_test_data

    visit "merchants/#{@merchant2.id}/invoices/#{@invoice_15.id}"

    expect(page).to have_content("Total Price(after discount): $365.20")
  end

  it "will alert user if there are no discounts" do
    load_test_data

    visit "merchants/#{@merchant1.id}/invoices/#{@invoice_1.id}"

    expect(page).to have_content("Total Price(after discount): No discount applied")
  end

  it ""





end