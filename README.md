# Docker-based ClamAV server

> There are many like it, but this one is mine...

Run a ClamAV daemon for scanning all your infected files.  Keeping the definition
database up-to-date is handled by a separate instance of the same container.
Your choice of TCP or Unix socket for remote connectivity.


# Usage

Run the clamd server in one container:

    docker run -v /srv/docker/clamav/database:/var/lib/clamav discourse/clamav clamd

Then run the freshclam updater in another container, making sure it's using the
same `/var/lib/clamav` directory:

    docker run -v /srv/docker/clamav/database:/var/lib/clamav discourse/clamav freshclam

... and you're done.  Unless you want funky configuration, in which case, read on.


# Configuration

You can set any valid configuration options in `clamd.conf` or `freshclam.conf` via
environment variables.  The way it works is that any environment variable whose
name starts with `CLAMD_CONF_` or `FRESHCLAM_CONF_` will be used as a configuration
option for the relevant file.  The prefix is removed, the remainder of the environment
variable name used as the configuration parameter name, and the environment variable
value used as the configuration parameter value.

For example, if you ran the following command:

    docker run -e CLAMD_CONF_TCPSocket=31337 -e CLAMD_CONF_LogVerbose=yes discourse/clamav clamd

Then `clamd.conf` would look like this:

```
TCPSocket 31337
LogVerbose yes
```

By default, if you do not specify an option, it will not be written to the configuration
file.  The only exceptions to this are:

* **`User`**: this defaults to `clamav` if not set explicitly.

* **`DatabaseDirectory`**: this defaults to `/var/lib/clamav` if not set explicitly.

* **`Foreground`**: this will *always* be set to `yes`; if you attempt to change that,
  the container will fail to start.


## Users and Permissions

The username specified in `User` must already exist.

To ensure that everything is going to work OK, the directory specified by `DatabaseDirectory`
will be created and set to be owned by the user specified by `User`.
