RSpec.feature 'Cart' do
  let(:router)              { Router.new }
  let(:user)                { User.new }
  let(:product_slug)        { 'ruby-on-rails-tote' }
  let(:second_product_slug) { 'ruby-on-rails-baseball-jersey' }
  let(:coupon_code)         { { name: 'test', code: 'test1', discount: 20 } }

  scenario 'has empty cart' do
    visit router.cart_path

    aggregate_failures do
      expect(page).to have_css('h1', text: 'Shopping Cart')
      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
      expect(page).to have_css('.btn-default', text: 'Continue shopping')

      click_on 'Continue shopping'
      expect(page).to have_current_path router.products_path
    end
  end

  describe 'Not empty Cart' do
    before { add_to_cart(product_slug) }

    scenario 'has more than one product' do
      add_to_cart(second_product_slug)

      aggregate_failures do
        expect(page).to have_css('.line-item', count: 2)

        total = all('.cart-item-total').map { |price| convert_to_float(price) }.inject(:+)
        cart_total = convert_to_float(find('.cart-total .lead'))

        expect(total).to eq cart_total
      end
    end

    scenario 'has cart info in header' do
      add_to_cart(second_product_slug, 3)

      total = all('.cart-item-total').map { |price| convert_to_float(price) }.inject(:+)
      quantity = all('.line_item_quantity').map { |input| input.value.to_i }.inject(:+)

      expect(find('.cart-info').text).to eq "Cart: (#{quantity}) $#{total}"
    end

    scenario 'product has name, price, image and description' do
      visit_product(product_slug)

      name = find('.product-title').text
      description = find('.well').text
      description = "#{description[0..96]}..." if description.size > 96
      image = image_name(find('#main-image img'))
      price = find('.price.selling').text

      visit router.cart_path

      cart_description = find('.line-item-description').text
      cart_image = image_name(find('.cart-item-image img'))

      aggregate_failures do
        expect(page).to have_css('h4', text: name)
        expect(image).to eq cart_image
        expect(description).to eq cart_description
        expect(find('.cart-item-price').text).to eq price
      end
    end

    scenario 'applies coupon code' do
      add_to_cart(second_product_slug, 3)
      
      fill_in 'order_coupon_code', with: coupon_code[:code]
      click_button 'Apply'

      subtotal = convert_to_float(find('.cart-subtotal h5', text: '$'))
      discount = (subtotal * coupon_code[:discount] / 100).round(2)
      cart_discount = convert_to_float(find('.adjustment h5', text: '$'))

      aggregate_failures do
        expect(page).to have_css('h5', text: "Promotion: Promotion (#{coupon_code[:name]})")
        expect(discount).to eq cart_discount
      end
    end

    scenario 'updates cart' do
      find('.line_item_quantity').set 5

      click_button 'Update'

      price = convert_to_float(find('.cart-item-price'))
      total = (price * find('.line_item_quantity').value.to_f).round(2)
      pdp_total = convert_to_float(find('.cart-item-total'))

      expect(total).to eq pdp_total
    end

    scenario 'empties cart' do
      add_to_cart(second_product_slug, 3)

      find('#clear_cart_link input').click

      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    scenario 'removes product' do
      find('.delete').click

      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    scenario 'removes product when quantity is 0' do
      find('.line_item_quantity').set 0

      click_button 'Update'

      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    scenario "User's cart is saved" do
      create_user(user.email, user.password)

      visit_product(product_slug)
      name = find('.product-title').text

      visit router.cart_path

      aggregate_failures do
        expect(page).to have_css('h4', text: name)

        logout
        login(user)

        visit router.cart_path
        expect(page).to have_css('h4', text: name)
      end
    end

    # Create scenarios after making Checkout tests
    xscenario 'has tax'
    xscenario 'has subtotal and total price'
  end
end
