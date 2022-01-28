#! /bin/sh

set -vx

tar -zxvf  /faq/files_phpmyfaq-3.0.12.tar.gz -C /data

mkdir -p /data/phpmyfaq/attachments
mkdir -p /data/phpmyfaq/data
mkdir -p /data/phpmyfaq/images

chmod -R 777 /data/* 