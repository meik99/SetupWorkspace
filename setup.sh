#!/bin/bash
if [ "$EUID" -ne 0 ] then
  echo "Script must have root priviliges"
  exit
fi

apt update && apt upgrade -yf
