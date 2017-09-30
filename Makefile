							# current directory (full path)
CWD = $(CURDIR)
							# module name (short directory name)
MODULE = $(notdir $(CWD))
							# host OS
ifeq ($(shell uname -m),Windows_NT)
	OS = win32
else
	OS = linux
endif
							# host ARCHitecture
ARCH = $(shell uname -m)

							# temp dir
TMP = $(CWD)/tmp
							# dir for external program source archives
GZ = $(CWD)/gz
WGET = wget --no-check-certificate -c -P $(GZ)

.PHONY: default
default: neo4j

# Interpreter core

log.log: src.src ./exe.exe
	./exe.exe < $< > $@ && tail $(TAIL) $@
C = cpp.cpp ypp.tab.cpp lex.yy.c
H = hpp.hpp ypp.tab.hpp 
L =
CXXFLAGS += -std=gnu++11
./exe.exe: $(C) $(H) $(L)
	$(CXX) $(CXXFLAGS) -o $@ $(C) $(L)
ypp.tab.cpp: ypp.ypp
	bison $<
lex.yy.c: lpp.lpp
	flex $<

# pull github
.PHONY: pull
pull:
	git pull &
	cd wiki ; git pull &

# LaTeX manual
.PHONY: manual
manual: doc/manual.pdf
doc/manual.pdf:
	cd doc ; $(MAKE)
	
# full system rollup
.PHONY: install
install: neo4j neo_py
	
# neo4j & knowledge database kernel rollup

NEO_VER = 3.2.5
NEO = neo4j-community-$(NEO_VER)
ifeq ($(OS),win32)
	NEO_GZ = $(NEO)-windows.zip
	NEO_BIN = $(NEO)/bin/neo4j.bat
	NEO_SH  = $(NEO)/bin/neo4j-shell.bat
else
	NEO_GZ = $(NEO)-unix.tar.gz
	NEO_BIN = $(NEO)/bin/neo4j
	NEO_SH  = $(NEO)/bin/neo4j-shell
endif
NEO_DB  = $(NEO)/data/databases/graph.db

.PHONY: neo4j neo_py
neo4j: $(NEO)/README.txt
$(NEO)/README.txt: $(GZ)/$(NEO_GZ)
ifeq ($(OS),"win32")
		unzip $< && touch $@
else
		tar zx < $< && touch $@
endif
$(GZ)/$(NEO_GZ):
	$(WGET) -O $@ https://neo4j.com/artifact.php?name=$(NEO_GZ)
neo_py:
ifeq ($(OS),win32)
	pip install neo4j-driver
else
	sudo pip install neo4j-driver
endif

# run server system
.PHONY: run
run: neo4j
	$(NEO_BIN) console
.PHONY: dump
dump: neo4j
	$(NEO_SH) -path $(NEO_DB) -c dump > KB.dump.cql
