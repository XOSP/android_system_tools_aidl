#
# Copyright (C) 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

aidl_cflags := -Wall -Wextra -Werror

#
# Everything below here is used for integration testing of generated AIDL code.
#
aidl_integration_test_cflags := $(aidl_cflags) -Wunused-parameter
aidl_integration_test_shared_libs := \
    libbase \
    libbinder \
    liblog \
    libutils

include $(CLEAR_VARS)
LOCAL_MODULE := libaidl-integration-test
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_CFLAGS := $(aidl_integration_test_cflags)
LOCAL_SHARED_LIBRARIES := $(aidl_integration_test_shared_libs)
LOCAL_AIDL_INCLUDES := \
    system/tools/aidl/tests/ \
    frameworks/native/aidl/binder
LOCAL_SRC_FILES := \
    tests/android/aidl/tests/ITestService.aidl \
    tests/android/aidl/tests/INamedCallback.aidl \
    tests/simple_parcelable.cpp
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := aidl_test_service
LOCAL_CFLAGS := $(aidl_integration_test_cflags)
LOCAL_SHARED_LIBRARIES := \
    libaidl-integration-test \
    $(aidl_integration_test_shared_libs)
LOCAL_SRC_FILES := \
    tests/aidl_test_service.cpp
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := aidl_test_client
LOCAL_CFLAGS := $(aidl_integration_test_cflags)
LOCAL_SHARED_LIBRARIES := \
    libaidl-integration-test \
    $(aidl_integration_test_shared_libs)
LOCAL_SRC_FILES := \
    tests/aidl_test_client.cpp \
    tests/aidl_test_client_file_descriptors.cpp \
    tests/aidl_test_client_parcelables.cpp \
    tests/aidl_test_client_nullables.cpp \
    tests/aidl_test_client_primitives.cpp \
    tests/aidl_test_client_utf8_strings.cpp \
    tests/aidl_test_client_service_exceptions.cpp
include $(BUILD_EXECUTABLE)


# aidl on its own doesn't need the framework, but testing native/java
# compatibility introduces java dependencies.
ifndef BRILLO

include $(CLEAR_VARS)
LOCAL_PACKAGE_NAME := aidl_test_services
# Turn off Java optimization tools to speed up our test iterations.
LOCAL_PROGUARD_ENABLED := disabled
LOCAL_DEX_PREOPT := false
LOCAL_CERTIFICATE := platform
LOCAL_MANIFEST_FILE := tests/java_app/AndroidManifest.xml
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/tests/java_app/resources
LOCAL_SRC_FILES := \
    tests/android/aidl/tests/INamedCallback.aidl \
    tests/android/aidl/tests/ITestService.aidl \
    tests/java_app/src/android/aidl/tests/NullableTests.java \
    tests/java_app/src/android/aidl/tests/SimpleParcelable.java \
    tests/java_app/src/android/aidl/tests/TestFailException.java \
    tests/java_app/src/android/aidl/tests/TestLogger.java \
    tests/java_app/src/android/aidl/tests/TestServiceClient.java
LOCAL_AIDL_INCLUDES := \
    system/tools/aidl/tests/ \
    frameworks/native/aidl/binder
include $(BUILD_PACKAGE)

endif  # not defined BRILLO
