# README

### INSTALLATION STEPS & COMMANDS ---------------------------------------------

1. INSTALL RVM
   sudo apt-add-repository -y ppa:rael-gc/rvm
   sudo apt-get update
   sudo apt-get install rvm

# In order to always load rvm, change the Gnome Terminal toalways perform a login.

2. CONFIGURE RVM
   echo 'source "/etc/profile.d/rvm.sh"' >> ~/.bashrc

3. REBOOT

4. INSTALL RUBY
   rvm install ruby

5. CREATE AND USE ENVIRONMENT FOR PROJECT
   rvm gemset create {env_name}
   rvm gemset use {env_name}

6. INSTALL BUNDLER AND RAILS GEM
   gem install bundler
   gem install rails -v 5.2.3

7. NAVIGATE TO PROJECT FOLDER & INSTALL REQUIRED GEMS
   cd {project_name}
   bundle install

8. CONFIGURE DB IN RAILS CONFIG FILE, ENTER POSTGRES USERNAME AND PASSWORD IN ENVIRONMENT
   AND IMPORT FROM THERE
   // file-path = config/database.yml

9. SETUP DATABASE
   rails db::setup

10. RUN ALL MIGRATIONS
    db:migrate

11. RUN SERVER
    rails s


12. For ActiveJob, Sidekiq is used
    https://gist.github.com/wbotelhos/fb865fba2b4f3518c8e533c7487d5354
    **Run this command to run job server**
    bundle exec sidekiq -q default -q mailers
