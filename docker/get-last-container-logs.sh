#!/bin/bash
docker logs -f $(docker ps -lq)
