#define EOFnumber 0
#define SEMInumber 1 
#define COLONnumber 2 
#define COMMAnumber 3
#define DOTnumber 4 
#define LPARENnumber 5 
#define RPARENnumber 6
#define LTnumber 7
#define GTnumber 8
#define EQnumber  9
#define MINUSnumber 10 
#define PLUSnumber 11
#define TIMESnumber 12
#define DOTDOTnumber 13
#define COLEQnumber 14
#define LEnumber 15
#define GEnumber 16
#define NEnumber 17
#define IDnumber 18 
#define ICONSTnumber 19 
#define FCONSTnumber 20
#define CCONSTnumber 21
#define SCONSTnumber 22
#define ANDnumber 23
#define ARRAYnumber 24
#define BEGINnumber 25
#define CONSTnumber 26
#define DIVnumber 27
#define DOWNTOnumber 28
#define INTnumber 29
#define ELSEnumber 30
#define ELSIFnumber 31
#define ENDnumber 32
#define ENDIFnumber 33
#define ENDLOOPnumber 34
#define ENDRECnumber 35
#define EXITnumber 36
#define FORnumber 37
#define FORWARDnumber 38 
#define FUNCTIONnumber 39
#define IFnumber 40
#define ISnumber 41
#define LOOPnumber 42
#define NOTnumber 43
#define OFnumber 44
#define ORnumber 45
#define PROCEDUREnumber 46
#define PROGRAMnumber 47
#define RECORDnumber 48
#define REPEATnumber 49
#define FLOATnumber 50
#define RETURNnumber 51
#define THENnumber 52
#define TOnumber 53
#define TYPEnumber 54
#define UNTILnumber 55
#define VARnumber 56
#define WHILEnumber 57
#define PRINTnumber 58

#ifndef YYVAL
#define YYVAL
union {
  int semantic_value;
  float fvalue;
} yylval, yyval;
#endif

#define TABLE_SZ 100
