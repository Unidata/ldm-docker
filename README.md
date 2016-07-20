# LDM Docker

[![Travis Status](https://travis-ci.org/Unidata/ldm-docker.svg?branch=master)](https://travis-ci.org/Unidata/ldm-docker)

This repository contains files necessary to build and run a Docker container for the [LDM](http://www.unidata.ucar.edu/software/ldm/). 

## Pulling the Container

To pull the LDM container from the Docker Hub registry:

      docker pull unidata/ldm:latest

It is best to be on a fast network when pulling containers as they can be quite large.

## Building the Container

Alternatively, rather than pulling the container you can clone this repository and build the LDM Docker container yourself:

    docker build  -t unidata/ldm:latest .

It is best to be on a fast network when building containers as there can be many intermediate layers to download.

## Configuring the LDM

### Run Configuration with `docker-compose`

To run the LDM Docker container, beyond a basic Docker setup, we recommend installing [docker-compose](https://docs.docker.com/compose/).

You can customize the default `docker-compose.yml` to decide:

-   which LDM image version you want to run
-   which port will map to port `388`

For anyone who has worked with the LDM, you will be familiar with the following directories:

-   `etc/`
-   `var/data`
-   `var/logs`
-   `var/queues`

The `var/queues` directory will remain inside the container. The other directory paths will be mounted outside the container with `docker-compose.yml`

### LDM Configuration Files

In the `etc` directory, you will have to do the usual LDM configuration by editing:

-   `ldmd.conf`
-   `registry.xml`
-   `scour.conf`
-   `pqact.conf`

#### crontab

The [recommended LDM crontab entries](http://www.unidata.ucar.edu/software/ldm/ldm-current/basics/configuring.html#cron) have been installed inside the container. You can modify the LDM crontab by editing the `crontab` file. This `crontab` file is mounted outside the container with `docker-compose.yml`. For the new crontab to take effect, you will have to restart the container with

    docker restart <container ID>

Where the container ID is obtained with `docker ps`. See below for more information about running the LDM Docker container.

### Upstream Data Feed from Unidata or Elsewhere

The LDM operates on a push data model. You will have to find an institution who will agree to push you the data you are interested in. If you are part of the academic community please send a support email to `support-idd@unidata.ucar.edu` to discuss your LDM data requirements.

### Create LDM Directories on Docker Host

You will want to create the local directories defined in the `docker-compose.yml` for the LDM `/home/ldm/var/logs` directory and `/home/ldm/var/data` directory. For example:

    mkdir logs data

In typical LDM usage, the `data` directory is mounted on a data volume that can handle the amount of data you expect coming down the pipe. This `data` directory is usually not backed up.

### Running LDM

Once you have completed your `docker-compose.yml` setup, you can run the container with:

    docker-compose up -d

Note that if you have not pulled or built the LDM Docker image, this command will implicitly pull the image.

The output of such command should be something like:

    Creating ldm

### Stopping LDM

To stop this container:

    docker-compose stop

### Delete LDM Container

To clean the slate and remove the container (not the image, the container):

    docker-compose rm -f

## Volume Permission Caveats

There are often permission problems with the container not being able to write to the `~/var/logs`  and `~/var/data` directories which are externally mounted on the Docker host. Unfortunately, [the best practices in this area are still being worked out](https://www.reddit.com/r/docker/comments/46ec3t/volume_permissions_best_practices/?), and this can be the source of frustration with the user and group Unix IDs not matching inside versus outside the container. These scenarios can lead to big "permission denied" headaches. One, non-ideal, solution is to open up the permissions on those two directories to all users.

    chmod -R 777 logs data
    # Or wherever those externally mounted volumes exist

## Check What is Running

To verify the LDM is alive you can run `ldmadmin config` **inside** the container. To do that, run:

    docker exec -it `docker ps | tail -1 | cut -d " " -f 1` ldmadmin config

which should give output that looks something like:

    hostname:              changeme.foo.bar.com
    os:                    Linux
    release:               4.4.12-boot2docker
    ldmhome:               /home/ldm
    LDM version:           6.13.1
    PATH:                  /home/ldm/ldm-6.13.1/bin:/home/ldm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    LDM conf file:         /home/ldm/etc/ldmd.conf
    pqact(1) conf file:    /home/ldm/etc/pqact.conf
    scour(1) conf file:    /home/ldm/etc/scour.conf
    product queue:         /home/ldm/var/queues/ldm.pq
    queue size:            500M bytes
    queue slots:           default
    reconciliation mode:   do nothing
    pqsurf(1) path:        /home/ldm/var/queues/pqsurf.pq
    pqsurf(1) size:        2M
    IP address:            0.0.0.0
    port:                  388
    PID file:              /home/ldm/ldmd.pid
    Lock file:             /home/ldm/.ldmadmin.lck
    maximum clients:       256
    maximum latency:       3600
    time offset:           3600
    log file:              /home/ldm/var/logs/ldmd.log
    numlogs:               7
    log_rotate:            1
    netstat:               true
    top:                   /usr/bin/top -b -n 1
    metrics file:          /home/ldm/var/logs/metrics.txt
    metrics files:         /home/ldm/var/logs/metrics.txt*
    num_metrics:           4
    check time:            1
    delete info files:     0
    ntpdate(1):            ntpdate
    ntpdate(1) timeout:    5
    time servers:          ntp.ucsd.edu ntp1.cs.wisc.edu ntppub.tamu.edu otc1.psu.edu timeserver.unidata.ucar.edu
    time-offset limit:     10
