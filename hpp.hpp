#ifndef _H_HPP
#define _H_HPP

#include <iostream>
#include <cstdlib>
#include <vector>
#include <map>
using namespace std;

struct Sym {
	string tag,val;							// <T:V> pair
	Sym(string,string); Sym(string);		// consturctors
	virtual string dump(int=0);				// \ dump
	virtual string head(); string pad(int);	// /
	vector<Sym*> nest; void push(Sym*);		// nest[]ed elements
};

struct Str:Sym { Str(string); };
struct Num:Sym { Num(string); };

struct Vector:Sym { Vector(); };

struct Op:Sym { Op(string); };

extern int yylex();				// lexer/parser interface
extern int yylineno;
extern char* yytext;
#define TOC(C,X) { yylval.o = new C(yytext); return X; }	// token
extern int yyparse();
extern void yyerror(string);
#include "ypp.tab.hpp"

#endif // _H_HPP
