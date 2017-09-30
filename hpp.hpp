#ifndef _H_HPP
#define _H_HPP

#include <iostream>
#include <sstream>
#include <cstdlib>
#include <vector>
#include <map>
using namespace std;

struct Sym {
	string tag,val;								// <T:V> pair
	Sym(string,string); Sym(string);			// consturctors
	virtual string dump(int=0);					// \ dump
	virtual string head(); string pad(int);		// /
	vector<Sym*> nest; void push(Sym*);			// nest[]ed elements
	map<string,Sym*> attr; Sym* lookup(string);	// attr{}ibutes lookup
	virtual Sym* eval(Sym*);					// compute/evaluate
	virtual Sym* pfxadd();
	virtual Sym* pfxsub();
};

struct Env:Sym { Env(string); };			// environment
extern Env* glob;							// global env

struct Error:Sym { Error(string); };		// error

struct Str:Sym { Str(string); };			// string

struct Num:Sym { Num(string);				// number
	double val; Num(double); string head();	// use hardware float
	Sym* pfxadd(); Sym* pfxsub();
};

struct Vector:Sym { Vector(); };			// [vec tor]

struct Op:Sym { Op(string);					// op:erator
	Sym*eval(Sym*); };

extern int yylex();							// lexer/parser interface
extern int yylineno;
extern char* yytext;
#define TOC(C,X) { yylval.o = new C(yytext); return X; }	// token
extern int yyparse();
extern void yyerror(string);
#include "ypp.tab.hpp"

#endif // _H_HPP
