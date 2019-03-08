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
##### Run all specs:

`rspec <dir>`

##### Run specs with tag:

`rspec --tag tag_name <dir>`

or

`rspec --tag type:name <dir>`

##### Run specs in parallel mode:

`parallel_test <dir>` 

##### Run in specific browser:

`BROWSER=firefox rspec <dir>`

##### Run in head mode:
`HEADLESS=0 rspec <dir>`
