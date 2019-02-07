RSpec.feature 'test' do
  scenario 'test' do
    visit 'https://app.keepabl.com'
    fill_in 'user_email', with: 'bang@wp.pl'
    click_button 'Sign in'
    expect(page).to_not have_content 'Invalid Email or password.'
  end
end
