# VAGRANT UBUNTU GIT FLASK GUNICORN SUPERVISOR PROVISIONING

Just a little skeleton project to rapidly launch an Ubuntu 14.04 LTS Virtualbox using Vagrant and provision it out of the box with

* python
* pip
* virtualenv
* nginx
* gunicorn
* supervisor (with user)
* git (with post-receive deployment hook)

The bootstrap.sh contains a mash up setup guides I've followed to get a flask app server configured and running quickly for dev projects.

That file comprises the majority of the work in this project.

**Caveat**: This project is not intended for devops auto-deployments or any sort of production environment. This is pure localhost dev box.

## FEATURES

* rapid local linux python flask dev box launch, provisioning and configuration
* apt-get update only runs when updates are found
* configures a post-receive git deployment hook
* supervisor user is auto-generated

## PREREQUISITES

Please download the following to get started...

* Vagrant         [https://www.vagrantup.com/downloads.html]
* Virtual Box     [https://www.virtualbox.org/wiki/Downloads]

**NOTE**: _if you've never used Vagrant before, go through their [getting started guide][https://www.vagrantup.com/docs/getting-started/].
 It's pretty simple and fairly easy to get through. You'll be up and running in minutes._

## INSTALLATION

Once the prerequisites are installed, pop open a terminal and cd into the directory you cloned this project:

```cd vagrant-flask-supervisor```

If you've never installed a box using Vagrant before, you'll need to add a new box in your environment:

```vagrant box add ubuntu/trusty64```

**NOTE**: _existing Vagrant users may see errors stating you already have a box or that the Vagrantfile exists already.  This is ok. Vagrant is doing it's job._

## CONFIGURATION

* Port Forwarding:    Replace "host: 8080" with your own desired port (if you wish)
* Synced Files:       Replace "/Users/jmac/vm/.." with the path to your cloned repo (line 15) to ensure the configuration is correct.

## USAGE

Once your Vagrant setup is complete and your Vagrantfile is updated with your sync folder location, fire that puppy up...

```vagrant up```

Vagrant will import a base Ubuntu 14.04 LTS box, configure the VM using the Vagrantfile settings and provision it using bootstrap.sh

When it's complete, the last output from the bootstrap is **VAGRANT PROVISIONING - COMPLETE!**

Open a browser and point it to [http://127.0.0.1:8080]

### Additional Usage

If you need to reprovision the box, just run:

```vagrant reload --provision```

Or if you really want to start from scratch, run:

```
vagrant destroy
vagrant up
```

...and now you have a fresh box.

## FUTURE

* has the potential to create a yaml config script that the bootstrap.sh can read and populate with a real flask app project.

## RELEASES

2016-01-27 - hello world!