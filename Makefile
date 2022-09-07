# This makefile only makes the unit test, benchmark and pngdetail and showpng
# utilities. It does not make the PNG codec itself as shared or static library.
# That is because:
# LodePNG itself has only 1 source file (lodepng.cpp, can be renamed to
# lodepng.c) and is intended to be included as source file in other projects and
# their build system directly.


CC ?= gcc
CXX ?= g++

override CFLAGS := -W -Wall -Wextra -ansi -pedantic -O3 -Wno-unused-function $(CFLAGS)
override CXXFLAGS := -W -Wall -Wextra -ansi -pedantic -O3 $(CXXFLAGS)

SRC = src/lodepng.o src/lodepng_util.o

all: unittest benchmark pngdetail showpng

%.o: %.cpp
	@mkdir -p `dirname $@`
	$(CXX) -I ./ $(CXXFLAGS) -c $< -o $@

unittest: tests/lodepng_unittest.o $(SRC)
	$(CXX) $^ $(CXXFLAGS) -o tests/$@

benchmark: apps/lodepng_benchmark.o $(SRC)
	$(CXX) $^ $(CXXFLAGS) -lSDL2 -o apps/$@

pngdetail: apps/pngdetail.o $(SRC)
	$(CXX) $^ $(CXXFLAGS) -o apps/$@

showpng: examples/example_sdl.o $(SRC)
	$(CXX) -Isrc $^ $(CXXFLAGS) -lSDL2 -o examples/$@

examples/%.o: examples/%.cpp
	$(CXX) -Isrc -c $< $(CXXFLAGS) -o $@

src/%.o: src/%.cpp src/%.h 
	$(CXX) -Isrc -c $< $(CXXFLAGS) -o $@

apps/%.o: apps/%.cpp
	$(CXX) -Isrc -c $< $(CXXFLAGS) -o $@

tests/%.o: tests/%.cpp
	$(CXX) -Isrc -c $< $(CXXFLAGS) -o $@


clean:
	rm -fv tests/unittest apps/benchmark apps/pngdetail examples/showpng tests/*.o src/*.o apps/*.o examples/*.o
