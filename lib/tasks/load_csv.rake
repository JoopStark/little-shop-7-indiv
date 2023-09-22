require "csv"

namespace :load_csv do
  task all: [:customers, :merchants, :items, :invoices, :invoice_items, :transactions, :bulk_discounts] 

  task :customers => :environment do #team
    CSV.foreach("./db/data/customers.csv", headers: true, header_converters: :symbol) { |row| Customer.create(row) }
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end

  task :invoice_items => :environment do #Joop invoice_items
    CSV.foreach("./db/data/invoice_items.csv", headers: true, header_converters: :symbol) { |row| InvoiceItem.create(row) }
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  task :invoices => :environment do #Blake invoices
    CSV.foreach("./db/data/invoices.csv", headers: true, header_converters: :symbol) { |row| Invoice.create(row) }
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  task :items => :environment do #Noelle items
    CSV.foreach("./db/data/items.csv", headers: true, header_converters: :symbol) { |row| Item.create(row) }
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  task :merchants => :environment do #Allan merchants
    CSV.foreach("./db/data/merchants.csv", headers: true, header_converters: :symbol) { |row| Merchant.create(row) }
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
  end

  task :transactions => :environment do #Noelle transactions
    CSV.foreach("./db/data/transactions.csv", headers: true, header_converters: :symbol) { |row| Transaction.create(row) }
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end

  task :bulk_discounts => :environment do
    CSV.foreach("./db/data/bulk_discounts.csv", headers: true, header_converters: :symbol) { |row| BulkDiscount.create(row) }
    ActiveRecord::Base.connection.reset_pk_sequence!('bulk_discounts')
  end
end
