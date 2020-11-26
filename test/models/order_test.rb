require "test_helper"

describe Order do
  before do
    @order = orders(:order1)
  end
  describe "Relationships" do
    it "can have many order items" do
      expect(@order.orderitems.count).must_equal 2
    end

    it "can have many products through order items" do
      expect(@order.products.count).must_equal 2
    end

  end

  describe "Validations" do
    #all order validations only apply upon payment, not during cart
    it "is valid when all required fields are filled" do
      expect(@order.valid?).must_equal true
    end
    it "is still valid if a field is missing before checkout" do
      new_order = Order.create()

      expect(new_order.valid?).must_equal true
    end
  end

  describe "Custom Validations" do
    it "fails validation if cc num is less than 13 or more than 19 digits" do
      @order.cc_number = 1234
      expect(@order.valid?).must_equal false

      @order.cc_number = 12345678901234567890
      expect(@order.valid?).must_equal false
    end

    it "fails validation if cc exp date is in the past" do
      @order.cc_exp_date = "May 23, 1990"
      expect(@order.valid?).must_equal false

      @order.cc_exp_date = "May 23, 3000"
      expect(@order.valid?).must_equal true
    end

    it "fails validation if cc cvv is not a 3 digit number" do
      @order.cc_cvv = 12
      expect(@order.valid?).must_equal false
    end

  end

  describe "Custom Methods" do
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
      expect(@order.cc_number).must_equal 9999922221111

      expect(@order.last_digits).must_equal "1111"
    end
  end
end
