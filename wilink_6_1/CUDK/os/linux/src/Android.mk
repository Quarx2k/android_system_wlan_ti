LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

STATIC_LIB ?= y
DEBUG ?= y
DEBUG_TESTS ?= n
BUILD_SUPPL ?= y
BUILD_ODYSSEY_SUPPL ?= n
WPA_ENTERPRISE ?= y

ifeq ($(DEBUG),y)
    DEBUGFLAGS = -O2 -g -DDEBUG -DTI_DBG -fno-builtin
    ifeq ($(DEBUG_TESTS),y)
        DEBUGFLAGS += -DTI_DBG_TESTS
    endif
else
    DEBUGFLAGS = -O2
endif

WILINK_ROOT = ../../../..
CUDK_ROOT = $(WILINK_ROOT)/CUDK
TI_SUPP_LIB_DIR = $(WILINK_ROOT)/../../../../external/wpa_supplicant_6/wpa_supplicant

DK_DEFINES = 
ifeq ($(WPA_ENTERPRISE), y)
    DK_DEFINES += -D WPA_ENTERPRISE
endif

ifeq ($(BUILD_SUPPL), y)
    DK_DEFINES += -D WPA_SUPPLICANT -D CONFIG_CTRL_IFACE -D CONFIG_CTRL_IFACE_UNIX
    -include external/wpa_supplicant_6/wpa_supplicant/.config
    ifeq ($(CONFIG_WPS), y)
        DK_DEFINES += -DCONFIG_WPS
    endif
endif

LOCAL_CFLAGS += \
    -Wall -Wstrict-prototypes $(DEBUGFLAGS) -D__LINUX__ -DANDROID \
    $(DK_DEFINES) -D__BYTE_ORDER_LITTLE_ENDIAN -fno-common 

LOCAL_SRC_FILES:= \
	cu_wext.c \
	ipc_sta.c \
	ipc_event.c \
	ipc_wpa.c \
	os_trans.c \
	ParsEvent.c \
        osapi.c


LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/../inc \
        $(LOCAL_PATH)/../../common/inc \
        $(LOCAL_PATH)/$(WILINK_ROOT)/stad/Export_Inc \
        $(LOCAL_PATH)/$(WILINK_ROOT)/stad/src/Sta_Management \
        $(LOCAL_PATH)/$(WILINK_ROOT)/stad/src/Application \
        $(LOCAL_PATH)/$(WILINK_ROOT)/utils \
        $(LOCAL_PATH)/$(WILINK_ROOT)/Txn \
        $(LOCAL_PATH)/$(WILINK_ROOT)/TWD/TWDriver \
	$(LOCAL_PATH)/$(WILINK_ROOT)/TWD/FirmwareApi \
	$(LOCAL_PATH)/$(WILINK_ROOT)/TWD/FW_Transfer/Export_Inc \
	$(LOCAL_PATH)/$(WILINK_ROOT)/TWD/TwIf \
        $(LOCAL_PATH)/$(WILINK_ROOT)/platforms/os/linux/inc \
        $(LOCAL_PATH)/$(WILINK_ROOT)/platforms/os/common/inc \
        $(LOCAL_PATH)/$(WILINK_ROOT)/TWD/FirmwareApi \
        external/wpa_supplicant_6/wpa_supplicant \
        external/wpa_supplicant_6/wpa_supplicant/src  \
        external/wpa_supplicant_6/wpa_supplicant/src/common \
        external/wpa_supplicant_6/wpa_supplicant/src/utils \
        $(LOCAL_PATH)/$(CUDK_ROOT)/configurationutility/inc

LOCAL_MODULE:=libtiOsLib

include $(BUILD_STATIC_LIBRARY)

