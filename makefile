EXECUTABLE_NAME := app.exe

#no trailing "/"
SRC_DIR := src
OBJ_DIR := obj
TARGET_DIR := target

#debug / release
MODE := release

# x64 / Win32 / linux
TARGET := linux

SRC_FILES := $(wildcard $(SRC_DIR)/*.cpp)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/$(TARGET)/$(MODE)/%.o,$(SRC_FILES))

CC := g++
CXXFLAGS := -Wall -Wextra

ifeq ($(MODE), debug)
CXXFLAGS := $(CXXFLAGS) -g
else
CXXFLAGS := $(CXXFLAGS) -O3
endif

ifeq ($(TARGET), x64)
CC := x86_64-w64-mingw32-g++
else ifeq ($(TARGET), Win32)
CC := i686-w64-mingw32-g++
endif

#create the executable
$(TARGET_DIR)/$(TARGET)/$(MODE)/$(EXECUTABLE_NAME): $(OBJ_FILES)
	$(CC) $(LDFLAGS) -o $@ $^
	cp $@ $(EXECUTABLE_NAME)

#compile all libaries
$(OBJ_DIR)/$(TARGET)/$(MODE)/%.o: $(SRC_DIR)/%.cpp
	$(CC) $(CXXFLAGS) -c -o $@ $<

#build all possible versions of the project
all:
	make MODE=release TARGET=linux
	make MODE=debug TARGET=linux

	make MODE=release TARGET=x64
	make MODE=debug TARGET=x64

	make MODE=release TARGET=Win32
	make MODE=debug TARGET=Win32