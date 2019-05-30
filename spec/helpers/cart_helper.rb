# frozen_string_literal: true

module CartHelper
  def add_to_cart(slug, _quantity = 1)
    visit_product(slug)

    product_name = find('.product-title').text
    find('#quantity').set 5

    find('#add-to-cart-button').click

    product_name
  end
end
