#!/bin/sh

perl Makefile.PL

gcc -c -fPIC search.c
make
make install
