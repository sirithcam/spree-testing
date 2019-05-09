RSpec.feature 'Product Listing Page' do
  describe 'Sidebar' do
    scenario 'has Categories'
    scenario 'has Brands'
    scenario 'Categories leads to proper page'
    scenario 'Brands leads to proper page'
    scenario 'Categories has proper items'
    scenario 'Brands has proper items'
    scenario 'Categories has sub-categories with proper items'
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
