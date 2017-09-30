#ifndef _H_HPP
#define _H_HPP

#include <iostream>
#include <cstdlib>
using namespace std;

struct Sym {
	string tag,val;
	Sym(string,string); Sym(string);
	virtual string dump();
};

struct Str:Sym { Str(string); };
struct Num:Sym { Num(string); };

struct Op:Sym { Op(string); };

extern int yylex();				// lexer/parser interface
extern int yylineno;
extern char* yytext;
#define TOC(C,X) { yylval.o = new C(yytext); return X; }	// token
extern int yyparse();
extern void yyerror(string);
#include "ypp.tab.hpp"

#endif // _H_HPP
