
%{
#include "synt1.tab.h"
extern  nb_ligne;
extern YYSTYPE yylval;
#include "fonction1.h"
#include <stdlib.h>
%}
lettres [a-zA-Z]
chiffres [+-]?[0-9]+
chiffres_e [+-]?[0-9]+("."[0-9]+)?
idf "$"{lettres}({lettres}|{chiffres}|_)*
idf_tableau "@"{lettres}({lettres}|{chiffres}|_)*
string \"[^"]*\"
commentaire "##"[^"]*"##"

%%

import return mc_import;
ISIL.io {yylval.str=strdup(yytext);
      return bib_isil_io;}
ISIL.lang {yylval.str=strdup(yytext);
      return bib_isil_lang;}
public return mc_public;
private return mc_private;
protected return mc_protected;
class return mc_class;
Entier {  yylval.str=strdup("Entier");
         return mc_entier;}
Reel {yylval.str=strdup("Reel");
      return mc_reel;}
Chaine {yylval.str=strdup("Chaine");
         return mc_chaine;}
CONST return mc_const;
main return mc_main;
In return mc_in;
Out return mc_out;
For return mc_for;
; return pvg;
{string} {
      yylval.str=strdup(yytext);
      return mc_string;}
{commentaire} {nb_ligne = nb_ligne + nombreLigneCommentaire(yytext);}
{lettres} return lettres;
{idf} {if (yyleng < 20){ inserer(yytext, "idf");
                        yylval.str=strdup(yytext);
                        return idf;}
         else printf ("erreur lexical a la ligne %d: l'idf %s trop long\n",nb_ligne,yytext);}

{idf_tableau} {if(yyleng < 20){ inserer(yytext, "idf_tableau"); yylval.str=strdup(yytext); return idf_tableau;}
                        else {printf ("erreur lexical a la ligne %d: l'idf %s trop long\n",nb_ligne,yytext);}}

{chiffres} {yylval.entier=atoi(yytext);
            return cst;}
            
{chiffres_e} {yylval.reel=atof(yytext);
            return cst_e;}

"<" return mc_inferieur;
">" return mc_superieur;
">=" return mc_superieur_egale;
"<=" return mc_inferieur_egale;
"!=" return mc_different;
"+"  {yylval.str=strdup(yytext);
             return mc_addition;
			  }
"-" {yylval.str=strdup(yytext);
             return mc_soustraction;
			  }
"*" {yylval.str=strdup(yytext);
             return mc_multiplication;
			  }
"/" {yylval.str=strdup(yytext);
             return mc_division;
			  }
"{"  return mc_accolade_ouv;
"}" return mc_accolade_fer;
"[" return mc_crochet_ouv;
"]" return mc_crochet_fer;
"(" return mc_parenthese_ouv;
")" return mc_parenthese_fer;
":=" return mc_affectation;
"=" return egale;
"," return vrg;
\" return mc_guillemet;
[ \t]
\n nb_ligne++;

. {printf("erreur lexical a ligne %d sur l'entite %s \n",nb_ligne,yytext);
   return erreur; }
