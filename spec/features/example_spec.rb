feature 'Sample Tests' do
  it_should_behave_like 'example', 'test1'

  scenario 'test2' do
    visit 'http://www.google.com'
    expect(page.current_url).to eq 'https://www.google.com/?gws_rd=ssl'
  end
end
