# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set(
  MESOS_TESTS_TARGET mesos-tests
  CACHE STRING "Target we use to refer to tests for the mesos"
  )

set(
  TEST_HELPER_TARGET test-helper
  CACHE STRING "Test helper target to run tests that require a subprocess"
  )

# COMPILER CONFIGURATION.
#########################
if (WIN32)
  STRING(REGEX REPLACE "/" "\\\\" CURRENT_CMAKE_SOURCE_DIR ${CMAKE_SOURCE_DIR})
  STRING(REGEX REPLACE "/" "\\\\" CURRENT_CMAKE_BUILD_DIR ${CMAKE_BINARY_DIR})
else (WIN32)
  set(CURRENT_CMAKE_SOURCE_DIR ${CMAKE_SOURCE_DIR})
  set(CURRENT_CMAKE_BUILD_DIR ${CMAKE_BINARY_DIR})
endif (WIN32)

add_definitions(-DSOURCE_DIR="${CURRENT_CMAKE_SOURCE_DIR}")
add_definitions(-DBUILD_DIR="${CURRENT_CMAKE_BUILD_DIR}")

add_definitions(-DPKGLIBEXECDIR="${PKG_LIBEXEC_INSTALL_DIR}")
add_definitions(-DTESTLIBEXECDIR="${TEST_LIB_EXEC_DIR}")
add_definitions(-DPKGMODULEDIR="${PKG_MODULE_DIR}")
add_definitions(-DSBINDIR="${S_BIN_DIR}")

# DEFINE PROCESS LIBRARY DEPENDENCIES. Tells the process library build targets
# download/configure/build all third-party libraries before attempting to build.
################################################################################
set(MESOS_TESTS_DEPENDENCIES
  ${MESOS_TESTS_DEPENDENCIES}
  ${MESOS_TARGET}
  ${GMOCK_TARGET}
  )

# DEFINE THIRD-PARTY INCLUDE DIRECTORIES. Tells compiler toolchain where to get
# headers for our third party libs (e.g., -I/path/to/glog on Linux)..
###############################################################################
set(MESOS_TESTS_INCLUDE_DIRS
  ${MESOS_TESTS_INCLUDE_DIRS}
  ${AGENT_INCLUDE_DIRS}
  ${GMOCK_INCLUDE_DIR}
  ${GTEST_INCLUDE_DIR}
  )

# DEFINE THIRD-PARTY LIB INSTALL DIRECTORIES. Used to tell the compiler
# toolchain where to find our third party libs (e.g., -L/path/to/glog on
# Linux).
########################################################################
set(MESOS_TESTS_LIB_DIRS
  ${MESOS_TESTS_LIB_DIRS}
  ${GMOCK_LIB_DIR}
  ${GTEST_LIB_DIR}
  )

# DEFINE THIRD-PARTY LIBS. Used to generate flags that the linker uses to
# include our third-party libs (e.g., -lglog on Linux).
#########################################################################
set(MESOS_TESTS_LIBS
  ${MESOS_TESTS_LIBS}
  ${MESOS_LIBS_TARGET}
  ${PROCESS_TARGET}
  ${MESOS_LIBS}
  ${GMOCK_LFLAG}
  ${GTEST_LFLAG}
  )

if (NOT WIN32)
  set(MESOS_TESTS_LIBS
    ${MESOS_TESTS_LIBS}
    ${QOS_CONTROLLER_TARGET}
    ${RESOURCE_ESTIMATOR_TARGET}
    ${LOGROTATE_CONTAINER_LOGGER_TARGET}
    )
endif (NOT WIN32)
