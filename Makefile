.PHONY: default
default: manual

# Interpreter core

log.log: src.src ./$(OS).exe
	./$(OS).exe < $< > $@ && tail $(TAIL) $@
C = cpp.cpp ypp.tab.cpp lex.yy.c
H = hpp.hpp ypp.tab.hpp 
L =
CXXFLAGS += -std=gnu++11
./$(OS).exe: $(C) $(H) $(L)
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