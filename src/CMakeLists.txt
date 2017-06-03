cmake_minimum_required(VERSION 3.6)
project(oracle-toddog-function)

set(CMAKE_C_STANDARD 11)

include_directories(/usr/include/oracle/12.2/client64)
set(SOURCE_FILES toddog.c toddog_udp.h toddog_udp.c)
add_library(toddog SHARED ${SOURCE_FILES})
