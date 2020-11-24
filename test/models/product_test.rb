require "test_helper"

describe Product do
  describe "validates" do
  end
  
  describe "relations" do
    describe "user" do
      it "can set the user using a User" do
        # Arrange
        user1 = users(:ada)
        product1 = products(:confidence)

        # Act & Assert
        expect(product1.user).must_equal user1
      end
  
      it "can set the user using a user_id" do
        # Arrange
        user1 = users(:ada)
        product1 = products(:confidence)

        # Act & Assert
        expect(product1.user_id).must_equal user1.id
      end
    end

    describe "orderitems" do
      it "can set the orderitem using a Orderitem" do
        # Arrange & Act
        product1 = products(:confidence)
        orderitem1 = orderitems(:orderitem1)

        # Assert
        expect(product1.orderitems.find(orderitem1.id)).must_equal orderitem1
      end

      it "can have many orderitems" do
        # Arrange & Act
        product1 = products(:confidence) # 6 orderitems in orderitem.yml

        # Assert
        expect(product1.orderitems.count).must_equal 6
      end
    end

    describe "categories" do
      it "can set the categories using a Category" do
        # Arrange
        product1 = products(:confidence)
        category2 = categories(:mental)

        # Act & Assert
        expect(product1.categories.find_by(name: "mental")).must_equal category2
      end

      it "can have many categories" do
        # Arrange & Act
        product2 = products(:python)

        category1 = categories(:cs)
        category2 = categories(:mental)

        # Assert
        expect(product2.categories.count).must_equal 2
      end
    end
  end
end
