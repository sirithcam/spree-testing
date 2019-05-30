RSpec.feature 'Product Listing Page' do
  let(:router)  { Router.new }

  before { visit router.root_path }

  scenario 'taxonomies has proper items' do
    taxons = all('.list-group-item').map(&:text)
    login_as_admin 

    taxons.each do |taxon|
      visit "/t/#{taxon.downcase}"
      products = all('.product-body').map(&:text)

      products.each do |product|
        find_admin_item(product)
        expect(page).to have_css('#product_taxons_field .select2-search-choice', text: taxon)
      end
    end
  end

  scenario 'taxonomies has sub-taxonomies with proper items' do
    visit router.subtaxon_plp_path
    taxons = all('.subtaxon-title').map(&:text)
    login_as_admin

    taxons.each do |taxon|
      visit router.subtaxon_plp_path

      parent_object = find('h5', text: /\A#{taxon}\z/).find(:xpath, '..')
      products = parent_object.all('.product-body').map(&:text)

      products.each do |product|
        find_admin_item(product)
        expect(page).to have_css('#product_taxons_field .select2-search-choice', text: taxon)
      end
    end
  end

  describe 'Sidebar' do
    scenario 'has taxonomies' do
      taxonomies = all('.taxonomy-root').map { |taxonomy| taxonomy.text.gsub('Shop by ', '') }

      taxons = {}
      all('.list-group').each_with_index do |group, index|
        taxons[taxonomies[index]] = group.all('.list-group-item').map(&:text) 
      end

      login_as_admin

      taxonomies.each do |taxonomy|
        visit router.admin_taxonomies_path
        find('tr', text: taxonomy).find('.icon-edit').click
        wait_for(error: 'Tree not loaded.') { all('#taxonomy_tree a').size == taxons[taxonomy].size + 1 }
        taxons[taxonomy].each { |taxon| expect(page).to have_css('#taxonomy_tree a', text: taxon) }
      end
    end

    scenario 'taxonomy links leads to proper page' do
      taxons = all('.list-group-item').map(&:text)

      taxons.each do |taxon|
        click_link taxon
        expect(page).to have_current_path "/t/#{taxon.downcase}"
      end
    end

    scenario 'selects Price Range' do
      visit router.price_range_plp_path
      price_ranges = all('.nowrap').map(&:text)

      price_ranges.each do |price_range|
        range = price_range.split.map { |price| price.delete('$-').to_f }
        range.delete(0)

        find('.nowrap', text: price_range).click
        find('#sidebar_products_search .btn').click

        all_prices = all('.price').map { |price| price.text.delete('$').to_f }

        if price_range.include?('over')
          all_prices.each { |price| expect(price).to be >= range[0] }
        elsif price_range.include?('Under')
          all_prices.each { |price| expect(price).to be <= range[0] }
        else
          all_prices.each { |price| expect(price).to be_between(range[0], range[1]).inclusive }
        end

        find('.nowrap', text: price_range).click
      end
    end
  end

  scenario 'Products has name, price and image' do
    product = all('.product-list-item').sample
    product_info = {
      name: product.find('a').text,
      image: product.find('img')[:src].split('/').last,
      price: product.find('.price')[:content]
    }

    login_as_admin

    find_admin_item(product_info[:name])

    aggregate_failures do
      expect(find('#product_name').value).to eq product_info[:name]
      expect(find('#product_price').value).to eq product_info[:price]

      click_link 'Images'

      images = all('#content img').map { |img| img[:src].split('/').last }

      expect(images).to include product_info[:image]
    end
  end

  describe 'Pagination' do
    scenario 'has Next link' do
      active = find('.pagination .active').text.to_i
      find('.pagination').click_link 'Next'

      expect(find('.pagination .active').text.to_i).to eq active + 1
    end

    scenario 'has Last link' do
      find('.pagination').click_link 'Last'
      
      expect(all('.pagination .page').last[:class]).to include 'active'
    end

    scenario 'has Previous link' do
      all('.pagination .page').reject { |page| page[:class].include? 'active' }.sample.find('a').click

      active = find('.pagination .active').text.to_i
      find('.pagination').click_link 'Prev'

      expect(find('.pagination .active').text.to_i).to eq active - 1
    end

    scenario 'has First link' do
      all('.pagination .page').reject { |page| page[:class].include? 'active' }.sample.find('a').click

      find('.pagination').click_link 'First'

      expect(find('.pagination .active').text.to_i).to eq 1
    end

    scenario 'has proper active page' do
      all('.pagination .page').reject { |page| page[:class].include? 'active' }.sample.find('a').click
      page_number = find('.pagination .active').text

      expect(page).to have_current_path "/?page=#{page_number}"
    end
  end
end
