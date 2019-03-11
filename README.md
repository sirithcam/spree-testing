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

### Setup .env

In order to launch raw tests all variables from `.env.sample` has to be filled with proper values.

#### Syntax:

In each operating system, it is assumed that all environment variables will be uppercase so please follow this convention.

`VARIABLE_STRING='string'`<br>
`VARIABLE_INT=1`

#### Necessary Variables

`APP_HOST` - URL to your project, e.g. `APP_HOST='https://secret-project.herokuapp.com'`

`#APP_HOST= # Production` - commented line for production URL. If you want tests to be performed on production environment comment previous line and uncomment this one.

`BROWSER` - value should be the same as a name of the browser registered in `spec/helpers/drivers` directory.<br>
E.g. `Capybara.register_driver :chrome do |app|` in this line of code we register Chrome Browser and the name is `:chrome` set as a Ruby symbol. In our `.env` file we should convert it to a normal string, so the value will be `BROWSER='chrome'`.

`FULLSCREEN` - takes two values, `0` as false and `1` as true. Determinates if a tests should be launched in fullscreen mode.

`HEADLESS` - takes two values, `0` as false and `1` as true. Determinates if a tests should be launched in headless browser mode.

## Running Tests
#### Run all specs:

`rspec <dir>`

#### Run specs with tag:

`rspec --tag tag_name <dir>`

or

`rspec --tag type:name <dir>`

#### Run specs in parallel mode:

`parallel_test <dir>` 

*NOTE: Parallel mode configuration file is `.rspec_parallel`.*

#### Run in specific browser:

`BROWSER=firefox rspec <dir>`

#### Run in head mode:

`HEADLESS=0 rspec <dir>`

#### Run in non-fullscreen mode:

`FULLSCREEN=0 rspec <dir>`

## Writing's conventions

### Test scheme
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

Use `scenario` over `it`, `scenario` is dedicated for Feature Tests and `it` for Unit Tests.

If you want to split your tests use `describe` and then `context`. E.g.:

```
describe 'Header' do
  context 'Visibility' do
    ...
  end
end
```

### Tags

Tags in RSpec are very usefull when our tests are very complex. By using Tags we can divide our test cases into several groups/sections so when we need to run tests only on one section of our application we can run it using aforementioned Tags.

E.g. we can divide tests by it's priority from `low` to `high` and when we do not have so much time for running all tests we can simply run only tests that has `high` priority instead.

#### Syntax

Tags should be assigned after a name of a test or `describe/context` block by putting a hash with keys and values. 

E.g.

```
scenario 'User is created`, priority: 'high' do
  ...
end
```

```
describe 'Checkout', { regression: true, priority: 'medium' } do
  ...
end
```

#### Usage

Filter examples with a simple tag:<br>
`rspec <dir> -t regression`

Filter examples with a `name:value` tag:<br>
`rspec <dir> -t priority:high`

Exclude examples:<br>
`rspec <dir> -t ~regression`

### Helpers

Names of each helper module should contain name of a module or page that is in the app itself in upper camel case system (e.g. `AdminPanelHelper`).<br>
File has to be stored in `spec/helpers/` directory.<br>
After creating new helper add this line to `spec/spec_helper.rb`:

`config.include YourModuleHelper`

After all `config.include` lines.

### Shared examples

#### When to use them?

There will be a lot of cases in which tests will look very similar to each other and a code can be shared between them. In this situation `shared_examples` are perfect to use.<br>
Also sometimes there will be need to check the same page as a registered User and a Guest. In this situation `shared_examples` with many scenarios are handy.

#### How to use them?

All `shared_examples` files are stored in `spec/shared_examples` and are named the same as file that uses them but without `_spec` in the name. E.g. `spec/shared_examples/checkout_page.rb`.

**Scheme:**

In `spec/shared_examples/*.rb`:

```
shared_examples name do |var1, var2, ..., varN|
  scenario name do
    ...
  end
  
  scenario var2 do
    ...
  end
end
```

*Note: In `shared_examples` there can be one or more scenarios.*

**Usage:**

In `spec/feature/*_spec.rb` file add this:

`it_should_behave_like name, var1, var2, ..., varN`

### Images and upload files

All non-Ruby files that are used in the test scenarios has to be stored in `spec/fixtures` directory.<br>
E.g. images, documents, etc.

### Rubocop

Just before making Pull Request with your code, please make sure to use `rubocop` to check your code and make all requested changes. Some of them can be ommited, this needs to be discused separately in each project.

**Usage:**

`rubocop <dir>`

or for auto-correct:

`rubocop -a <dir>`

*Note: `rubocop` configs are stored in `.rubocop.yml`*

### Debugging

To debug your code simply add `binding.pry` before the line that you want to debugg.

#### Why `pry` over `byebug`??

Actually, we are using the mix of both gems called `pry-byebug` which merges both gem's features into one big gem! 

`pry` gives us a powerfull console which is similar to Ruby's `irb` in which we can freely paste block of codes and has nice syntax colors.

`byebug` on the other hand, is a great tool to debugg our tests step by step, which in pure `pry` is impossible.

*Note: All `pry-byebug` config are stored in `.pryrc` file. Also all shortcuts from pure `byebug` are stored there so you can use them freely.*

### .gitingore

In this file we store all file names and file's extentions that we do not want to send into our repository.<br>
Those are:
- All log files
- Files with passwords
- Text editor's files
- Operating System temporary files
- etc.

**IMPORTANT! Your local .env file cannot be uploaded to a repository!**

### Logs and summary

All log files are stored in `logs/` directory and are excluded from git. After each scenario log with test summary are created.<br>
Also, when any test is failing, screenshot in which a fail occurs is taken and stored in `logs/screenshots` and the exect directory and name of a screenshot is being displayed in summary just after a name of failing error.

Naming: `spec_summary_YYYY-MM-DD-hh:mm:ss.log`

**Preview:**

`cat <log_path>`

`open <screenshot_path>`

*Note: Configs for summary and logs are stored in `.rspec` and `.rspec_parallel`.*

### Drivers

Each driver has to be registered within `Capybara` before we can use them. All configuration files are stored in `spec/helpers/drivers` directory and are named `*_driver.rb`. Inside of this files we can determine the browser options and it's path. 

The current driver's binary file path is `vendor/`. All binary files for each browser is stored there. 

In order to update a driver just replace old binary file with the newest one.

## Default options

**.env:**

```
HEADLESS=1
FULLSCREEN=1
BROWSER=chrome
```
### Why?

**HEADLESS** - testing should always be enabled on `master` branch because `master` branch should be used only for starting tests on staging or production. `HEADLESS=0` may be used only on a branch where tests are being writing on but should be set back to 1 before pushing last commit.

**FULLSCREEN** - normal User browsers in fullscreen mode in 95% of time so we should test it like this. 
If a test needs a smaller resolution(e.g. to scroll down) then we can use this in test itself:

`Capybara.page.driver.browser.manage.window.resize_to(1240, 1400)`

**BROWSER** - Google Chrome browser is the most popular browser right now. And developers on real app repository uses headless Chrome browser on their test cases. But this value is the most flexible one as it depends on each project.

