cmake_minimum_required(VERSION 3.6)
project(oracle-toddog-function)

set(CMAKE_C_STANDARD 11)

#include_directories(sdk/include)
set(SOURCE_FILES toddog.c)
add_library(concat SHARED ${SOURCE_FILES})
