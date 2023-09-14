class Merchant <ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  # has_many :invoices
  has_many :customers, through: :invoices

  def self.top_customers
    # find_by_sql(
    #   "SELECT customers.*, COUNT(invoices.status)
	  #   FROM customers 
	  #   INNER JOIN invoices ON invoices.customer_id = customers.id 
	  #   GROUP BY customers.id
	  #   ORDER BY count DESC
	  #   LIMIT 5")
      Merchant.select("customers.*, COUNT(invoices.status)")
      .joins(:customers)
      .where("invoices.customer_id = customers.id")
      .group("customers.id")
      .order("count desc")
      .limit(5)
  end
end