CloudRunner.IO Scripts library
===============================

Copyright (c) 2013-2014 CloudRunner.IO_

About
--------

CloudRunner.IO_ is a simple yet powerful framework for remote server management.

It's key features include:

* **Execute scripts** in your choice(bash, python, ruby, puppet and chef-solo recipes)

* Pass **environment variables** between servers and between different script languages (works for a limited number of languages, but can be extended with a plugin)

* Secure communication using **SSL** certificates

* **Fast and reliable**, using ZeroMQ as a transport backend(although a different backend can be used as a plugin)

* CloudRunner.IO_ also offers a commercial server, that performs a lot of useful tasks, including:

    * **User management**: assign roles for different users on different remote servers(how to impersonate an user on a server)
    * **Library management**: store, re-use scripts into different kind of stores - GitHub, ButBucket, SVN, Dropbox, Google Drive, Microsoft OneDrive, etc.
    * **Workflow management** - run multi-step scripts on different servers, with the ability to restart a script from arbitrary step, while keeping the environment context as it was in the first run.
    * **Web dashboard** for performing different operational tasks and for monitoring latest activities using filters.
    * Execution of **scheduled tasks** (using Cron)
    * **Triggers** - invoke stored script execution when a specific pattern appear in the activity logs.
    * **Highly customizable platform** - write your own plugins(in Python) for different kind of workflow management.
    * **Multi-tenancy** - supports isolated group of users who can access servers in a shared environment (including public clouds).
    * **HA and Multi-server routing** - install master servers in different locations(subnets, public clouds, etc.) and access all your servers from a single access point. No need to attach to different master server to access a remote server into directly inaccessible network. All you need is to allow the master servers to see each other.

    For more details see `www.cloudrunner.io
    <http://www.cloudrunner.io>`_ or ask for details at info@cloudrunner.io


Developing CloudRunner
-------------------------

CloudRunner CLI/Agent is an open-source project under the Apache 2 license. See the code at `www.github.com/cloudrunner
<http://www.github.com/cloudrunner/>`_. Everyone is welcome to contribute.


.. _CloudRunner.IO: http://www.cloudrunner.io