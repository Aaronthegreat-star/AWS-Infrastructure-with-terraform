#!/bin/bash

sudo apt update -y

sudo apt install apache2 -y

sudo systemctl start apache2.service

sudo systemctl enable apache2.service
