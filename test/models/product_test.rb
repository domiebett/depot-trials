require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(
                         title: "Title",
                         description: "Description",
                         image_url: "7apps.jpg"
    )
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
                product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert product.errors[:price].any?

    product.price = 1
    assert product.valid?
  end

  test "product image url must be an image" do
    ok = [ "image.jpg", "dis_image.gif", "whodatt.png", "other.JPG" ]
    bad = [ "image.jpn", "dis_image.giffy", "whodatt.png.ping", "jpg.image" ]

    ok.each do |image_url|
      assert new_product(image_url).valid?
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?
    end
  end

  test "product title must be unique" do
    product = Product.new(
                         title: products(:ruby).title,
                         description: "Description",
                         price: 10,
                         image_url: "7apps.jpg"
    )
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  def new_product(image_url)
    Product.new(
               title: "Title",
               description: "Description",
               price: 1,
               image_url: image_url
    )
  end
end
