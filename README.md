## Instalation
1. Create new repo for your project.
2. `git clone git@github.com:spark-solutions/qa-automation-boilerplate.git`
3. `mv qa-automation-boilerplate <your_project_name>`
4. `cd <your_project_name>`
5. `git remote add origin https://github.com/spark-solutions/<your_project_name>.git`
6. `git push origin master`
7. `bundle install`
8. `cp .env.sample .env`
9. Setup all necessary environment variables in `.env`.


## Usage
#### Run all specs:

`rspec <dir>`

#### Run specs with tag:

`rspec --tag tag_name <dir>`

or

`rspec --tag type:name <dir>`

#### Run specs in parallel mode:

`parallel_test <dir>` 

#### Run in specific browser:

`BROWSER=firefox rspec <dir>`

#### Run in head mode:

`HEADLESS=0 rspec <dir>`

#### Run in non-fullscreen mode:

`FULLSCREEN=0 rspec <dir>`

## Writing's conventions

#### Test scheme
```
RSpec.feature "User's Detailed Page" do
  describe 'Visibility' do
    scenario 'has title' do
      ...
    end
  end
end
```

Use `RSpec.feature` at the beggining of all tests, without this line tests won't work.

Use `scenario` over `it`, `scenario` is dedicated for Feature Tests and `it` for unit tests.

If you want to split your tests use `describe` and then `context`. E.g.:

```
describe 'Visibility' do
  context 'Header' do
    ...
  end
end
```

#### Helpers

Names of each helper module should contain name of a module or page that is in the app itself in upper camel case system (e.g. `AdminPanelHelper`).

File has to be stored in `spec/helpers/` directory.

After creating new helper add this line to `spec/spec_helper.rb`:

`config.include YourModuleHelper`

after all `config.include` lines.

## Default options

```
HEADLESS=1
FULLSCREEN=1
BROWSER=chrome
```
#### Why?

**HEADLESS** - testing should always be enabled on `master` branch because `master` branch should be used only for starting tests on staging or production. `HEADLESS=0` may be used only on a branch where tests are being writing on but should be set back to 1 before pushing last commit.

**FULLSCREEN** - normal User browsers in fullscreen mode in 95% of time so we should test it like this. 
If a test needs a smaller resolution(e.g. to scroll down) then we can use this in test itself:

`Capybara.page.driver.browser.manage.window.resize_to(1240, 1400)`

**BROWSER** - Google Chrome browser is the most popular browser right now. And developers on real app repositorium uses headless chrome browser in their test cases. But this value is the most flexible one as it depends on each project.

