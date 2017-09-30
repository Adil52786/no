#include "hpp.hpp"
#define YYERR "\n\n"<<yylineno<<":"<<msg<<"["<<yytext<<"]\n\n"
void yyerror(string msg) { cout<<YYERR; cerr<<YYERR; exit(-1); }
int main() { return yyparse(); }

Sym::Sym(string T,string V) { tag=T; val=V; }
Sym::Sym(string V):Sym("sym",V){}

string Sym::dump() { return "<"+tag+":"+val+">"; }

Str::Str(string V):Sym("str",V){}

Num::Num(string V):Sym("num",V){}

Op::Op(string V):Sym("op",V){}
