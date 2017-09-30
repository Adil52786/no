log.log: src.src ./$(OS).exe
C = cpp.cpp
H = hpp.hpp
L =
./$(OS).exe: $(C) $(H) $(L)
	$(CXX) $(CXXFLAGS) -o $@ $(C) $(L)