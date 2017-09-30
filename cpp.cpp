#include "hpp.hpp"
#define YYERR "\n\n"<<yylineno<<":"<<msg<<"["<<yytext<<"]\n\n"
void yyerror(string msg) { cout<<YYERR; cerr<<YYERR; exit(-1); }
int main() { return yyparse(); }

Sym::Sym(string T,string V) { tag=T; val=V; }
Sym::Sym(string V):Sym("sym",V){}

void Sym::push(Sym*o) { nest.push_back(o); }

string Sym::dump(int depth) { string S = "\n"+pad(depth)+head();
	for (auto it=nest.begin(),e=nest.end();it!=e;it++)
		S += (*it)->dump(depth+1);
	return S; }
string Sym::head() { return tag+":"+val; }
string Sym::pad(int n) { string S; for (int i=0;i<n;i++) S += '\t'; return S; }

Sym* Sym::lookup(string V) {
	if (attr.count(V)) return attr[V]; else return NULL; }
Sym* Sym::eval(Sym*E) {
	Sym*L = E->lookup(val); if (L) return L;			// env[lookup]
	for (auto it=nest.begin(),e=nest.end();it!=e;it++)	// loop over nest[]ed
		*it = (*it)->eval(E);							// ALARM: MEMORY LEAK
	return this; }

Sym* Sym::pfxadd() { return new Error(" + "+val); }
Sym* Sym::pfxsub() { return new Error(" - "+val); }

Error::Error(string V):Sym("error",V) { yyerror(V); }	// raise error

Str::Str(string V):Sym("str",V){}

Num::Num(string V):Sym("num",V) { val=atof(V.c_str()); }
Num::Num(double D):Sym("num","") { val=D; }
string Num::head() { ostringstream os;
	os << tag << ':' << val ; return os.str(); }

Sym* Num::pfxadd() { return this; }
Sym* Num::pfxsub() { return new Num(-val); }

Vector::Vector():Sym("vector","[]"){}

Op::Op(string V):Sym("op",V){}

Sym* Op::eval(Sym*E) { Sym::eval(E);
	if (nest.size()==1) {							// binary ops
		if (val=="+") return nest[0]->pfxadd();		// +A
		if (val=="-") return nest[0]->pfxsub();		// -A
	}
	return this; }

Env* glob = new Env("global");
Env::Env(string V):Sym("env",V){}
