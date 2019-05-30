# frozen_string_literal: true

RSpec.feature 'Product Detailed Page' do
  let(:router)       { Router.new }
  let(:product_slug) { find('#product_slug_field input').value }

  before do
    login_as_admin
    random_admin_item
    product_slug
  end

  scenario 'has breadcrumbs' do
    taxons = all('#s2id_product_taxon_ids .select2-search-choice').map { |taxon| taxon.text.split(' -> ') }.join(' ')

    visit_product(product_slug)

    breadcrumbs = find('#breadcrumbs').text.split.drop(2)
    expect(taxons).to include(*breadcrumbs)
  end

  scenario 'has name, description, image and price' do
    product_info = {
      name: find('#product_name').value,
      price: find('#product_price').value,
      description: find('#product_description').value
    }

    find('#sidebar a', text: 'Images').click

    product_info[:images] = image_names(all('.image img'))

    visit_product(product_slug)

    aggregate_failures do
      expect(find('.product-title').text).to eq product_info[:name]
      expect(find('.price').text).to eq "$#{product_info[:price]}"
      expect(find('.well').text).to eq product_info[:description]

      pdp_images = image_names(all('#product-images img'))
      expect(pdp_images).to include(*product_info[:images])
    end
  end

  scenario 'adds product to cart' do
    logout
    product_name = add_to_cart(product_slug, 5)

    aggregate_failures do
      expect(page).to have_css('h4', text: product_name)
      within('.cart-item-quantity') { expect(page).to have_css('input[value="5"]') }
    end
  end

  scenario 'has properties' do
    find('#sidebar a', text: 'Properties').click

    while all('.product_property').size == 1
      random_admin_item
      product_slug = find('#product_slug_field input').value
      find('#sidebar a', text: 'Properties').click
    end

    properties = {}
    all('.product_property')[0...-1].each do |property|
      name = property.find('.property_name input').value
      value = property.find('.value input').value

      properties[name] = value
    end

    visit_product(product_slug)

    aggregate_failures do
      expect(page).to have_css('.product-section-title', text: 'Properties')

      pdp_properties = all('#product-properties tr').map { |property| property.all('td').map(&:text) }
      pdp_properties.each do |property|
        expect(properties[property[0]]).to eq property[1]
      end
    end
  end

  scenario 'has variants' do
    visit router.variants_item_path
    product_slug = find('#product_slug_field input').value
    find('#sidebar a', text: 'Variants').click

    variants = []
    all('#content tr')[1..-1].each do |variant|
      variants << variant.all('td')[1].text
    end

    visit_product(product_slug)

    pdp_variants = all('.variant-description').map(&:text)
    expect(variants).to include(*pdp_variants)
  end

  scenario 'has similar items section' do
    taxons = all('#s2id_product_taxon_ids .select2-search-choice').map { |taxon| taxon.text.split(' -> ').last }

    visit_product(product_slug)

    similar_items = all('#similar_items_by_taxon li').map(&:text)
    expect(taxons).to include(*similar_items)
  end
end
