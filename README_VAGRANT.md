# First/one time setup

 * 
1. Start the VM (See below)
 * 
2. Start a work session (See below)
 * 
3. Type the following and press return: ./setup.sh
 * 
4. Once that's finished (it will take a while) you can now run the app (See below)



# Starting the Virtual Machine

 * 
1. Launch a command prompt - For Windows use the Git command prompt
 * 
2. Type the following and press return: cd dovetail
 * 
3. type the follwing and press return: vagrant up



# Stopping the Virtual Machine

Generally I just leave the original window I ran vagrant up in open so I don't need to open the shell window everytime.

 * 
1. Launch a command prompt - For Windows use the Git command prompt
 * 
2. Type the following and press return: cd dovetail
 * 
3. type the follwing and press return: vagrant halt



# Starting a work session

Note, the VM must be running already (See above)

 * 
1. Launch a command prompt - For Windows use the Git command prompt
 * 
2. Type the following and press return: cd dovetail
 * 
3. Type the following and press return: vagrant ssh
 * 
4. Type the following and press return: cd /vagrant
 * 
5. You are now logged in and the current directory is set to the dovetail project
 * 
6. Do work (ie run the setup.sh script, the update.sh script or start the app)



# Starting the App

 * 
1. Start a work sesssion (See above)
 * 
2. Type the following and press return: bundle exec rails s
 * 
3. Leave it running
 * 4. The app will be available at: http://lvh.me:4000/
 * 
5. Sent mail is readable at: http://lvh.me:4080/



# Stopping the App

 * 
1. Find the window that is running the app
 * 
2. Press Control-C to stop it.
 * 
3. Type the following and press return: exit 
 * 
4. You'll now be back at the windows prompt and the window can be closed.



# Updating gems and the schema

 * 
1. Start a work session (See above)
 * 
2. Or if the App is running, stop it (See above)
 * 
3. Type the following and press return: ./update.sh
 * 
4. The app can now be restarted (See above)


