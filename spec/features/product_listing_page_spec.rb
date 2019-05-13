RSpec.feature 'Product Listing Page' do
  before { visit '/' }

  describe 'Sidebar' do
    scenario 'has taxonomies' do
      taxonomies = all('.taxonomy-root').map { |taxonomy| taxonomy.text.gsub('Shop by ', '') }

      childs = {}
      all('.list-group').each_with_index do |group, index|
        childs[taxonomies[index]] = group.all('.list-group-item').map(&:text) 
      end

      login_as_admin

      taxonomies.each do |taxonomy|
        visit '/admin/taxonomies'
        find('tr', text: taxonomy).find('.icon-edit').click
        wait_for(error: 'Tree not loaded.') { all('#taxonomy_tree a').size == childs[taxonomy].size + 1 }
        childs[taxonomy].each { |child| expect(page).to have_css('#taxonomy_tree a', text: child) }
      end
    end

    scenario 'taxonomy childs leads to proper page' do
      childs = all('.list-group-item').map(&:text)

      childs.each do |child|
        click_link child
        expect(page).to have_current_path "/t/#{child.downcase}"
      end
    end

    scenario 'taxonomies has proper items'
    scenario 'taxonomies has sub-taxonomies with proper items'
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
