wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.7.zip
unzip rubygems-1.8.7.zip
cd rubygems-1.8.7
ruby setup.rb --prefix=~/gems/

cd ..
rm -r rubygems-1.8.7 rubygems-1.8.7.zip

