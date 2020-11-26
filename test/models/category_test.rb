require "test_helper"

describe Category do
  before do
    @category = categories(:mental)
  end

  describe "Validations" do
    it 'is valid when all fields are filled' do
      expect(@category.valid?).must_equal true
    end

    it 'fails validation when there is no name' do
      @category.name = nil

      expect(@category.valid?).must_equal false
    end

    it 'fails validation when name already exists' do
      @category2 = Category.create(name: @category.name)

      expect(@category2.valid?).must_equal false
    end
  end

  describe 'Relationships' do
    it 'can have many products' do
      product1 = products(:confidence)
      product2 = products(:python)
      expect(@category.products.count).must_equal 2
      @category.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end

    it 'belongs to many products' do
      product1 = products(:confidence)
      product2 = products(:python)
      expect(product1.categories).must_include @category
      expect(product2.categories).must_include @category
    end

    it 'can have many users through products' do
      user1 = users(:ada)
      user2 = users(:grace)

      expect(@category.users.count).must_equal 2
      @category.users.each do |user|
        expect(user).must_be_instance_of User
      end
    end
  end
end
