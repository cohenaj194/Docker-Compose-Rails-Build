# Automated Ruby on Rails build using Docker Compose

This is an automated buildout of the following tutorial:

https://docs.docker.com/compose/rails/

If you dont have docker and docker-compose installed run `sh Docker-Compose-Rails-Build/install.sh`.

Afterwards copy your rails project into the `Docker-Compose-Rails-Build/rails` directory.  If you dont have a project yet thats fine too `Docker-Compose-Rails-Build/rails/make.sh` can also give you a fresh rails environment to start from. 

Last run the following:

   cd Docker-Compose-Rails-Build/rails
   sudo sh make.sh