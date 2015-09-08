
# MGMT6963-2015
[http://rpi-analytics.github.io/MGMT6963-2015](http://rpi-analytics.github.io/MGMT6963-2015). 

This is a configuration for a vagrant machine customized for analytics. The system uses chef [Chef](http://www.opscode.com/chef/) recipe installs and configures all the dependencies for  IPython Notebooks and R Studio Server. 

#Requirements
Prior to launching this you should download [Vagrant](http://www.vagrantup.com/downloads.html) and Virtualbox.

#Launching the Virtual Machine
To launch the virtual machine clone the git repository. Then in the repository directory type `vagrant up`

#Customizing the VM
There are a wide variety of recipes used, and you can add or remove as desired. Simply identify the desired package from the [Chef Supermarket](https://supermarket.chef.io) and it to the Cheffile. You could also create your own custom chef cookbooks to configure the virtual machine however you desire.  Then execute the `librarian-chef update` command to add the cookbook to the /cookbooks path (double check that the associated directory is there).  Then add the associated cookbook to the Vagrantfile. Execute the additional change with `vagrant provision`.

## Credits
This VM utilizes as a base box for the [Spark Mooc](https://github.com/spark-mooc/mooc-setup)

Other customizations created by Mario Rodas (@marsam on GitHub) and further adopted for Mining the Social Web by Matthew A. Russell.


