Pre-Setup Instructions (OSX)
The assumptions in the document included brew as an installed package, which
I can only assume means this will be run on some kind of OSX machine. Just to
ensure everything is working properly, these are the setup instructions for
ruby, RVM, brew, and mysql. Just in case.
1. Install the XCode Command Line Tools by running: `xcode-select --install`
  1a. You can check if you have them installed already by running 
  `xcode-select -p`. If they are installed, you'll get a directory.
  Otherwise, you'll get an error.
2. Install Homebrew. Run:
`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)`
  2a. You might need sudo password to do this.
3. Use brew to install mysql: `brew install mysql`
  3a. You'll need to also setup mysql to run on startup (and possible right
  now). Those commands are given immediately after brew is done installing.
  3b. You'll also need to set the password on the admin user and/or create new
  users for specific access points. As you'll see later, I just made it use 
  root/admin so I've avoided a lot of specific steps about creating specific 
  users.
4. Install GPG and the RVM key:
`brew install gpg`
`command curl -sSL https://rvm.io/mpapis.asc | gpg --import -`
5. Install RVM:
`\curl -L https://get.rvm.io | bash -s stable`
  4a. After RVM installs, you'll need to either `source ~/.rvm/scripts/rvm` or
  close and reopen the terminal.
6. Install a version of ruby through RVM: `rvm install ruby-<version>`
Since I happen to be using ruby 2.2.4, `rvm install ruby-2.2.4` should be okay.
  6a. You can also setup other things like gemsets that are convenient for
  development, but totally unnecessary for just running the thing.
The machine should now have a good version of ruby, brew, RVM, and mysql. The
only thing that is outside of the assumptions that was installed was RVM, and
that was purely for a simple way to get a ruby version, and shouldn't affect
any of the setup afterwards.
If you don't want RVM to be used, instead of steps 4, 5, and 6, simply just run
`brew install ruby` instead. This should give you the latest ruby version.
Ruby 2.2.4 is hardly the latest version though, so there could be compatibility
issues.  There shouldn't be, but there could.

Instructions to run the app server
0. Setup assumes that you have compatible versions of ruby and mysql.
  0a. This was also written in regards to the rails development environment
  (RAILS_ENV=development). You may need to set the appropriate environment
  if you are going to run in a different environment.
1. Update rubygems: `gem update --system`
  1a. This is more or less a 'just in case' update.
2. Install bundler: `gem install bundler`
3. Navigate to the loan app directory (<this directory>/loan). `cd loan`
4. Run `bundle install`
  4a. There might be errors here. Unfortunately, the only way I know to deal
  with these errors is to try and install each of the erroneous gems
  individually and deal with the problems for each one.
  So hopefully there's no errors.
5. Run `rake db:create db:migrate`
  5a. I have my user/password set to root/admin, which is probably the least
  secure thing ever. If you guys have a different setup on the machine this
  is being run on, you'll want to change the config/database.yml file to match.
6. Run `rails server` to start the server
  5a. This should by default start the webrick web server on localhost:3000

Navigating the app
There are only two pages on the app: The new form page (/loan_applications/new)
which is also set as the root (so accessing localhost:3000 will take you to the
same page), and the show page (/loan_applications/<id>, which simply gives the
loan id and the status of the loan.

Running tests
0. Run steps 0-4 in the "Instructions to run the server" section if you haven't
already.
  0a. Also run `rake db:create` if you haven't already in step 5.
  0b. You should be in the loan application directory.
1. Run `rake db:migrate RAILS_ENV=test`
2. Run `rspec` or `bundle exec rspec`
  2a. If this doesn't work, you can use the binstub command:
  `bundle binstubs rspec-core`
  This should allow you to run the specs with `bin/rspec` instead.