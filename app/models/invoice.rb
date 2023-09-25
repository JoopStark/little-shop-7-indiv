require "csv"

class Invoice < ApplicationRecord
  enum status: ["completed", "cancelled", "in progress"]
  has_many :invoice_items
  has_many :items, through: :invoice_items
  belongs_to :customer
  has_many :transactions
  validates_presence_of :customer_id
  validates_presence_of :status

  def self.incomplete
    where("status != 0")
  end

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
    # "Monday, July 18, 2019"
  end

  def total_revenue
    if self.items.count != 0
      items.select("SUM(invoice_items.quantity * items.unit_price) AS total")[0].total
    else
      0
    end
  end

  def self.with_discounts(invoice_id)
    find_by_sql(
      ["SELECT DISTINCT invoice, merch, id, item_id, unit_price, MAX(discount_value) AS discount_value, MIN(new_price) AS new_price, MAX(percentage) AS percentage, true_quantity FROM
          (SELECT invoices.id AS invoice, merchants.id AS merch, consolidated_invoice_items.id, consolidated_invoice_items.invoice_id, consolidated_invoice_items.item_id, consolidated_invoice_items.unit_price, items.name, true_quantity,
            CASE WHEN consolidated_invoice_items.true_quantity >= bulk_discounts.threshold THEN consolidated_invoice_items.true_quantity * consolidated_invoice_items.unit_price * bulk_discounts.discount
            ELSE 0
            END discount_value,
            CASE WHEN consolidated_invoice_items.true_quantity >= bulk_discounts.threshold THEN consolidated_invoice_items.true_quantity * consolidated_invoice_items.unit_price * ( 1 - bulk_discounts.discount )
            ELSE consolidated_invoice_items.true_quantity * consolidated_invoice_items.unit_price 
            END new_price,
            CASE WHEN consolidated_invoice_items.true_quantity >= bulk_discounts.threshold THEN discount * 100
            ELSE 0
            END percentage
          FROM invoices
          INNER JOIN 
            (SELECT item_id, MAX(id) AS id, invoice_id, unit_price, SUM(quantity) AS true_quantity FROM invoice_items
            WHERE invoice_id = ?
            GROUP BY invoice_items.item_id, invoice_items.invoice_id, invoice_items.unit_price) consolidated_invoice_items ON consolidated_invoice_items.invoice_id = invoices.id
          INNER JOIN items ON items.id = consolidated_invoice_items.item_id 
          INNER JOIN merchants ON merchants.id = items.merchant_id
          INNER JOIN bulk_discounts ON bulk_discounts.merchant_id = merchants.id) AS tablea
       GROUP BY invoice, merch, id, item_id, unit_price, name, true_quantity
       ORDER BY item_id;", invoice_id])
  end
end