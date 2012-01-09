#!/bin/sh
echo "START!!!!" > log.txt
date >> log.txt
apt-get install -y build-essential libssl-dev openssl libreadline6 libreadline6-dev git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion git-core
echo "apt-get finished." >> log.txt
date >> log.txt

#ruby1.9.2
echo "Ruby start." >> log.txt
date >> log.txt
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz
tar zxvf ruby-1.9.2-p290.tar.gz
cd ruby-1.9.2-p290
./configure
make -j
make install
echo "Ruby finished." >> log.txt
date >> log.txt

#Rails
echo "Rails start" >> log.txt
date >> log.txt
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
cd ..
gem update --system
gem update rake
gem install rails -v=3.0.9
echo "Rails finished" >> log.txt
date >> log.txt

# Sqlite3
echo "Sqlite3 start." >> log.txt
date >> log.txt
wget http://www.sqlite.org/sqlite-autoconf-3070701.tar.gz
tar zxf sqlite-autoconf-3070701.tar.gz
cd sqlite-autoconf-3070701/
./configure
make -j
make install
cd ..
gem install sqlite3-ruby
gem install sqlite3
echo "Sqlite3 finished." >> log.txt
date >> log.txt

# Check
echo "ruby & rails check" >> log.txt
ruby -v >> log.txt
rails -v >> log.txt

# Test Rails App
rails new testapp --skip-bundle
cd testapp
#echo "gem 'therubyracer'" >> Gemfile
echo "gem 'unicorn'" >> Gemfile
echo "gem 'nifty-generators'" >> Gemfile
echo "gem 'mocha'" >> Gemfile
bundle install
rails g nifty:scaffold Book title:string price:integer
rails g nifty:layout -f
rake db:migrate
bundle exec unicorn_rails -D
ufw allow 8080

echo "Finish!!!!!" >> ../log.txt
date >> ../log.txt
cat ../log.txt
exit

# Please Access http:// global-ip :8080/books/
