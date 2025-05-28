# Docker compose project reaper

[Moby-ryuk](https://github.com/testcontainers/moby-ryuk), but for docker compose.

## Use case

Your tests require dependencies running in docker containers, that are set up with docker compose. When your tests start, you bring the dependencies up and when your tests complete, you shut them down. But what will happen if your tests crash? There will be a bunch of containers left up. This container can help you in such a scenario.

## How?

* Start the reaper, mounting docker socket, exposing keep alive port and providing docker compose project name
  ```
  docker run -it -v /var/run/docker.sock:/var/run/docker.sock -p 2222:2222 --rm jrosiek/compose-reaper:latest PROJECT
  ```

* Connect to the keep alive socket.

  This should happen within your test process (eg. in the setup of test fixture), so that the crash of the process will terminate the connection.
  If the connection is lost or not established within 10s timeout, the reaper will attempt to shut down the docker compose project.

  ```
  nc localhost 2222
  ```

* Start the docker compose project providing explicit project name that must agree with the argument to the reaper
  ```
  docker compose -p PROJECT -f docker-compose.yml up
  ```

And that's all. You don't even have to explicitly shut down the docker compose project in your tests. The reaper will take care of it.

