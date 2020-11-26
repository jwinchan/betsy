require "test_helper"

describe Order do
  describe "Relationships" do

  end

  describe "Validations" do

  end

  describe "Custom Validations" do

  end

  describe "Custom Methods" do
    before do
      @order = orders(:order1)
    end
    
    it "marks orderitems as paid only when order payment is completed" do
      expect(@order.orderitems.first.order_status).must_equal "pending"

      @order.mark_as_paid

      expect(@order.orderitems.first.order_status).must_equal "paid"
    end

    it "updates product stock only when order payment is completed" do
      expect(@order.products.first.stock).must_equal 100

      @order.update_stock

      expect(@order.products.first.stock).must_equal 99
    end

    it "sums up order subtotals" do
      expect(@order.total).must_equal 40005
    end

    it "only shows last 4 digits of credit card number" do
      expect(@order.cc_number).must_equal 22221111

      expect(@order.last_digits).must_equal "1111"
    end
  end
end
