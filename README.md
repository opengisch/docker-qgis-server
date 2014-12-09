docker-qgis-server-webclient
============================

A simple docker container that runs QGIS MapServer complete with a QGIS web client.
it Is based on http://github.com/opengisch/docker-qgis-server


**Note** this is a demonstrator project only and you should revise the security
etc of this implementation before using in a production environment.

To use the image, either pull the latest trusted build from 
https://registry.hub.docker.com/u/opengisch/docker-qgis-server-webclient/ by doing this:

```
docker pull opengisch/qgis-server-webclient
```

or build the image yourself like this:

```
docker build -t opengisch/qgis-server-webclient git://github.com/opengisch/docker-qgis-server-webclient
```

**Note:** The 'build it yourself' option above will build from the develop branch
wheras the trusted builds are against the master branch.


To run a container do:

```
docker run --name "qgis-server-webclient" -p 8081:80 -d -t opengisch/qgis-server-webclient
```

Probably you will want to mount the /web folder with local volume
that contains some QGIS projects. 

```
docker run --name "qgis-server-webclient" \
    -v <path_to_local_qgis_project_folder>:/web \
    -p 8081:80 -d -t opengisch/qgis-server-webclient
```

Replace ``<path_to_local_qgis_project_folder>`` with an absolute path on your
filesystem. That folder should contain the .qgs project files you want to
publish and all the data should be relative to the project files and within the
mounted volume.


Also consider looking at https://github.com/kartoza/docker-qgis-orchestration
which provides a cloud infrastructure including QGIS Server.

-----------
Marco Bernasocchi (marco@opengis.ch)
December 2014
Tim Sutton (tim@linfiniti.com)
May 2014
