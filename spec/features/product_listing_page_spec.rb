RSpec.feature 'Product Listing Page' do
  let(:subtaxon_url) { '/t/clothing' }

  before { visit '/' }

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
    visit subtaxon_url
    taxons = all('.subtaxon-title').map(&:text)
    login_as_admin

    taxons.each do |taxon|
      visit subtaxon_url

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
        visit '/admin/taxonomies'
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

    scenario 'selects Price Range'
  end

  describe 'Products' do
    scenario 'has name'
    scenario 'has price'
    scenario 'has image'
    scenario 'has link to detailed page'
  end

  describe 'Pagination' do
    scenario 'has Next link'
    scenario 'has Last link'
    scenario 'has First link'
    scenario 'has proper active page'
  end
end
