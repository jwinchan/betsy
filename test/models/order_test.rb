require "test_helper"

describe Order do
  describe "Relationships" do

  end

  describe "Validations" do

  end

  describe "Custom Validations" do

  end

  describe "Custom Methods" do
    it "marks orderitems as paid only when order payment is completed" do
      @order = orders(:order1)

      expect(@order.orderitems.first.order_status).must_equal "pending"

      @order.mark_as_paid

      expect(@order.orderitems.first.order_status).must_equal "paid"
    end
    it "updates product stock only when order payment is completed" do
      @order = orders(:order1)

      expect(@order.products.first.stock).must_equal 100

      @order.update_stock

      expect(@order.products.first.stock).must_equal 99
    end

    it "sums up order subtotals" do
      
    end
  end
end
