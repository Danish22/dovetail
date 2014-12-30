# Starting the Virtual Machine

 * 1. Launch a command prompt - For Windows use the Git command prompt
 * 2. Type the following and press return: cd dovetail
 * 3. type the follwing and press return: vagrant up

# Stopping the Virtual Machine

Generally I just leave the original window open so I don't need to open the shell window everytime.

 * 1. Launch a command prompt - For Windows use the Git command prompt
 * 2. Type the following and press return: cd dovetail
 * 3. type the follwing and press return: vagrant halt

# Starting a work session

 * 0. Start the VM if needed (See above)
 * 1. Launch a command prompt - For Windows use the Git command prompt
 * 2. Type the following and press return: cd dovetail
 * 3. Start the VM if needed (See Above)
 * 4. Type the following and press return: vagrant ssh
 * 5. Type the following and press return: cd /vagrant
 * 6. You are now logged in and the current directory is set to the project directory
 * 7. Do work (ie start the app, See below)

# First/one time setup

 * 0. Install Runtime: get and install latest Vagrant and VirtualBox (Already done)
 * 1. Launch a command prompt - For Windows use the Git command prompt
 * 2. Grab sources eg: git clone.. (Already done)
 * 3. Start the VM (See above)
 * 4. Start a work session (See above)
 * 5. Type the following and press return: ./setup.sh
 * 6. Once that's finished (it will take a while) you can now run the app (See below)

# Starting the App

 * 1. Start a work sesssion (See above)
 * 2. Type the following and press return: bundle exec rails s
 * 3. Leave it running

# Stopping the App

 * 1. Find the window that is running the app
 * 2. Press Control-C to stop it.
 * 3. Type the following and press return: exit 
 * 4. You'll now be back at the windows prompt and the window can be closed.

# Updating gems and the schema

 * 1. Start a work session (See above)
 * 2. Or if the App is running, stop it (See above)
 * 3. Type the following and press return: ./update.sh
 * 4. The app can now be restarted (See above)


