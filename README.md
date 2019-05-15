# LDM Docker

[![Travis Status](https://travis-ci.org/Unidata/ldm-docker.svg?branch=master)](https://travis-ci.org/Unidata/ldm-docker)

This repository contains files necessary to build and run a Docker container for the [LDM](http://www.unidata.ucar.edu/software/ldm/). 

## Versions

- `unidata/ldm-docker:latest`
- `unidata/ldm-docker:6.13.11`
- `unidata/ldm-docker:6.13.10`
- `unidata/ldm-docker:6.13.7`
- `unidata/ldm-docker:6.13.6`

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

These directory paths will be mounted outside the container with `docker-compose.yml`

### LDM Configuration Files

In the `etc` directory, you will have to do the usual LDM configuration by editing:

-   `ldmd.conf`
-   `registry.xml`
-   `scour.conf`
-   `pqact.conf`

#### crontab

The [recommended LDM crontab entries](http://www.unidata.ucar.edu/software/ldm/ldm-current/basics/configuring.html#cron) have been installed inside the container. You can modify the LDM crontab by editing the `cron/ldm` file. This  file can be mounted over `/var/spool/cron/ldm` with `docker-compose.yml`. See the `docker-compose.yml` file herein for an example.

#### Additional Scouring

The scouring facilities built-in to the LDM mysteriously do not have the ability to scour empty directories. In this container, therefore, are included additional scouring utility scripts that will scour empty directories as well.

- `scourBYnumber`
- `scourBYempty `
- `scourBYday`

Typically, these will be invoked from cron and will correspond to the same directories being scoured in `scour.conf`. For example, if you have a `scour.conf` that has the following entries:

```
/data/ldm/pub/decoded/gempak/areas/ANTARCTIC	2
/data/ldm/pub/decoded/gempak/areas/ARCTIC	2
/data/ldm/pub/decoded/gempak/areas/GEWCOMP	4
```

you may wish to have corresponding entries in your crontab (e.g., `cron/ldm` file that will be mounted into the container with `docker-compose.yml`) file:

```
16 0 * * * /home/ldm/util/scourBYday /data/ldm/pub/decoded/gempak/areas/ANTARCTIC 2
17 0 * * * /home/ldm/util/scourBYday /data/ldm/pub/decoded/gempak/areas/ARCTIC    2
18 0 * * * /home/ldm/util/scourBYday /data/ldm/pub/decoded/gempak/areas/GEWCOMP   4
```

### Upstream Data Feed from Unidata or Elsewhere

The LDM operates on a push data model. You will have to find an institution who will agree to push you the data you are interested in. If you are part of the academic community please send a support email to `support-idd@unidata.ucar.edu` to discuss your LDM data requirements.

### Create LDM Directories on Docker Host

You will want to create the local directories defined in the `docker-compose.yml` for the LDM `/home/ldm/var/logs` directory and `/home/ldm/var/data` directory. For example:

    mkdir logs data

In typical LDM usage, the `data` directory is mounted on a data volume that can handle the amount of data you expect coming down the pipe. This `data` directory is usually not backed up.

### Running LDM

Once you have completed your `docker-compose.yml` setup, you can run the container with:

    docker-compose up -d ldm

Note that if you have not pulled or built the LDM Docker image, this command will implicitly pull the image.

The output of such command should be something like:

    Creating ldm

### Stopping LDM

To stop this container:

    docker-compose stop

### Delete LDM Container

To clean the slate and remove the container (not the image, the container):

    docker-compose rm -f

## Check What is Running

To verify the LDM is alive you can run `ldmadmin config` **inside** the container. To do that, run:

    docker exec ldm ldmadmin config

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
## Running LDM (or Other Shell) Commands Inside the Container

When using the LDM in any realistic scenario, you will want to execute LDM commands (e.g., `notifyme`). There are a couple of different ways you can accomplish this goal.

1. You can enter the container with `docker exec -it <container name or ID> bash`. For example,

 ```bash
 $ docker exec -it ldm bash
 [ldm@291c06984ded ~]$ notifyme -vl- -h idd.unidata.ucar.edu
 ```

2. Or you can simply execute the command from outside the container with `docker exec <container name or ID> <command>`. For example,

 ```bash
 docker exec ldm notifyme -vl- -h idd.unidata.ucar.edu
 ```
## Updating the LDM

When Unidata releases a new version of the LDM, it is easy to update the container:

```bash
docker pull unidata/ldm-docker:<version>
docker-compose stop
docker-compose up -d ldm
```

## Configurable LDM UID and GID

The problem with mounted Docker volumes and UID/DIG mismatch headaches is best explained here: https://denibertovic.com/posts/handling-permissions-with-docker-volumes/.

This container allows the possibility of controlling the UID/GID of the `ldm` user inside the container via `LDM_USER_ID` and `LDM_GROUP_ID` environment variables. If not set, the default UID/GID is `1000`/`1000`. For example,


```bash
docker run --name ldm  \
     -e LDM_USER_ID=`id -u`  \
     -e LDM_GROUP_ID=`getent group $USER | cut -d':' -f3`  \
     -v ./etc/:/home/ldm/etc/ \
     -v ./data/:/home/ldm/var/data/ \
     -v ./data/:/home/ldm/var/queues/ \
     -v ./logs/:/home/ldm/var/logs/ \
     -v ./cron/:/var/spool/cron/ \
     -d -p 388:388 unidata/ldm-docker:latest
```

where `LDM_USER_ID` and `LDM_GROUP_ID` have been configured with the UID/GID of the user running the container. If using `docker-compose`, see `compose.env` to configure the UID/GID of user `ldm` inside the container.

This feature enables greater control of file permissions written outside the container via mounted volumes (e.g., data files written by the LDM).

Note that this UID/GID configuration option will not work on operating systems where Docker is not native (e.g., macOS).

## Citation

In order to cite this project, please simply make use of the Unidata LDM DOI: doi:10.5065/D64J0CT0 https://doi.org/10.5065/D64J0CT0
## Self-Contained Example

This project comes with a self-contained example. To run it:

1. `docker pull unidata/ldm-docker:latest`
2. `cd example`
3. possibly edit `etc/registry.xml` to change hostname currently set at `ldm-example.jetstream-cloud.org`
4. possibly edit `etc/registry.xml` to change the LDM queue size currently set at `2G`
5. edit `compose.env` to set `UID` and `GID` of user running container
6. `docker-compose up -d`


Assuming you have permission to request data from `iddb.unidata.ucar.edu` (see `example/etc/ldmd.conf`), after a few moments you should see data. For example:

```
./example/data/ldm/pub/native/radar/composite/grib2/N0R/20180301/Level3_Composite_N0R_20180301_2010.grib2
./example/data/ldm/pub/native/radar/composite/grib2/N0R/20180301/Level3_Composite_N0R_20180301_2015.grib2
./example/data/ldm/pub/native/radar/composite/grib2/N0R/20180301/Level3_Composite_N0R_20180301_2020.grib2
```

## Support

If you have a question or would like support for this LDM Docker container, consider [submitting a GitHub issue](https://github.com/Unidata/ldm-docker/issues). Alternatively, you may wish to start a discussion on the LDM Community mailing list: <ldm-users@unidata.ucar.edu>.

For general LDM questions, please see the [Unidata LDM page](https://www.unidata.ucar.edu/software/ldm/).
