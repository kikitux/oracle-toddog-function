#ifndef UDP_H
#define UDP_H

#define _GNU_SOURCE
#include <stdio.h>
#include <arpa/inet.h>
#include <errno.h>
#include <limits.h> // for HOST_NAME_MAX
#include <memory.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>

void udp(const unsigned short port, char* message);

#endif
