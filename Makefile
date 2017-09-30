							# current directory (full path)
CWD = $(CURDIR)
MODULE = $(notdir $(CWD))	# module name (short directory name)
OS = $(shell uname -o)		# host OS
ARCH = $(shell uname -m)	# host ARCH

							# dir for external program source archives
GZ = $(CWD)/gz

.PHONY: default
default: neo4j
	echo $(OS),$(ARCH),$(CWD)

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
	
# neo4j & knowledge database kernel rollup

WGET = wget --no-check-certificate -c -P $(GZ)

NEO4J_VER = 3.2.5
NEO4J = neo4j-community-$(NEO4J_VER)
NEO4J_GZ = $(NEO4J)-windows.zip

.PHONY: neo4j
neo4j: $(NEO4J)/README.txt
$(NEO4J)/README.txt: $(GZ)/$(NEO4J_GZ)
	unzip $< && touch $@
$(GZ)/$(NEO4J_GZ):
	$(WGET) -O $@ https://neo4j.com/artifact.php?name=$(NEO4J_GZ)
