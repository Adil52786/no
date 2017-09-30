log.log: src.src ./$(OS).exe
	./$(OS).exe < $< > $@ && tail $(TAIL) $@
C = cpp.cpp
H = hpp.hpp
L =
./$(OS).exe: $(C) $(H) $(L)
	$(CXX) $(CXXFLAGS) -o $@ $(C) $(L)