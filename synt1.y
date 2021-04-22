%{
    #include <stdlib.h>
   int nb_ligne =1;
   char sauvType[8];
   char sauvOpr[20];
   char sauvIdf[20];
   int sauvCst;
   char valcst[20];
   char temp[10];
   char temp1[10];
   char temp3[20];
   char temp2[10];
   char listeSF[30] = "";
   int j = 0;
   int biblang = 0;
   int bibio = 0;
   struct node {
        char nomIdf[20];
        struct node *next;
    };
    struct node *tete1=NULL;
    
%}


%union {
    int entier;
    char* str;
	float reel;
}

%token mc_import <str>mc_string mc_inferieur mc_superieur mc_superieur_egale mc_inferieur_egale mc_different lettres mc_for mc_out <str>bib_isil_io <str>bib_isil_lang pvg erreur mc_class mc_public mc_private
        mc_protected <str>idf mc_accolade_ouv mc_accolade_fer <str>mc_entier <str>mc_reel <str>mc_chaine vrg mc_crochet_ouv mc_crochet_fer <entier>cst <str>idf_tableau mc_const egale mc_affectation mc_main mc_parenthese_ouv
       mc_parenthese_fer mc_in mc_guillemet <str>mc_addition <str>mc_soustraction <str>mc_division <str>mc_multiplication <reel>cst_e 

%%
S: LISTE_BIB HEADER_CLASS mc_accolade_ouv CORPS CORPS_MAIN mc_accolade_fer {printf ("syntaxe correcte");
                    YYACCEPT;
					}
;


LISTE_BIB: BIB LISTE_BIB|
;

BIB: mc_import NOM_BIB pvg 
;

NOM_BIB: bib_isil_io{if (strcmp($1,"ISIL.io")==0){bibio = 1;}}|bib_isil_lang{if (strcmp($1,"ISIL.lang")==0){biblang = 1;}}
;


//----------------------------------------PARTIE CLASS-----------------------------------------------------------
HEADER_CLASS: MODIFICATEUR mc_class idf
;

MODIFICATEUR: mc_public|mc_private|mc_protected
;


//----------------------------- PARTIE MAIN--------------------------------------------------------------------

CORPS_MAIN: mc_main mc_parenthese_ouv mc_parenthese_fer mc_accolade_ouv LISTE_INSTRUCTION mc_accolade_fer
;

LISTE_INSTRUCTION: INSTRUCTION LISTE_INSTRUCTION
                       | 
;

INSTRUCTION: LECTURE | AFFECTATION | ECRITURE | BOUCLE
;

//-------------------------------------PARTIE BOUCLE -----------------------------------------------

BOUCLE: mc_for mc_parenthese_ouv INITIALISATION pvg CONDITION pvg INCREMENTATION mc_parenthese_fer mc_accolade_ouv LISTE_INSTRUCTION mc_accolade_fer
;

INITIALISATION: idf mc_affectation Z
{
    if (verifierTypeEntite($1,"Chaine")==0) {
        printf ("erreur semantique a la ligne %d : type de variable incompatible avec la boucle\n",nb_ligne);
    }
    if (doubleDeclaration($1)==0) {
        printf ("erreur semantique a la ligne %d : variable non declare\n",nb_ligne);
    } else {
        strcpy (temp1,$1);
    }
}
;

CONDITION: idf OPERATEUR_COMPARAISON Z 
{
    if (strcmp (temp1,$1) != 0) {
        printf ("erreur semantique a la ligne %d : variable de condition differente de celle dinitiallization\n",nb_ligne);
    }
}
;

OPERATEUR_COMPARAISON: mc_inferieur | mc_inferieur_egale | mc_superieur | mc_superieur_egale | mc_different
;

INCREMENTATION: idf Y
{
    if (strcmp (temp1,$1) != 0) {
        printf ("erreur semantique a la ligne %d : variable dincrementation differente de celle dinitiallization\n",nb_ligne);
    }
}
;

Y: mc_addition mc_addition | mc_soustraction mc_soustraction
;

Z : idf {if (doubleDeclaration($1)==0){
        printf ("erreur semantique a la ligne %d : variable %s non declare\n",nb_ligne,$1);
    }
   if (compareType($1,temp1) == -1) {
       printf ("erreur semantique a la ligne %d : Non compatibilite de type \n",nb_ligne);
   }   
}| cst {sauvCst = $1;}
;


//-----------------------------------------------------PARTIE ECRITURE-----------------------------------------------------------------



ECRITURE: mc_out mc_parenthese_ouv mc_string vrg liste_idf mc_parenthese_fer pvg 
{   
    if (bibio == 0) {printf ("erreur semantique a la ligne %d : bibliotheque ISIL.io non disponible\n",nb_ligne);}
    else {
        
        strcpy(temp2,$3);
        int i = 0;
        int k =0;
        for (i = 0 ; i < strlen(temp2)-1 ; i++){
            if (temp2[i]=='%' && temp2[i+1]=='d'){
			listeSF[k] = 'd';
		    k++;	
		    }
		    if (temp2[i]=='%' && temp2[i+1]=='f'){
            listeSF[k] = 'f';
		    k++;	
		    }
		    if (temp2[i]=='%' && temp2[i+1]=='s'){
            listeSF[k] = 's';
		    k++;
		    }
        }
        listeSF[k] = '\0'; 
        
    }
    struct node *p;
         p = tete1;
         int i= 0;
        while (i < strlen(listeSF) && p != NULL) {
            if (listeSF[i] == 'd' && verifierTypeEntite(p->nomIdf,"Entier") != 0) {
                printf ("erreur semantique a la ligne %d : non compabilite de type %s n'est pas un entier \n",nb_ligne,p->nomIdf);
            }
            if (listeSF[i] == 'f' && verifierTypeEntite(p->nomIdf,"Reel") != 0) {
                printf ("erreur semantique a la ligne %d : non compabilite de type %s n'est pas un Reel \n",nb_ligne,p->nomIdf);
            }
            if (listeSF[i] == 's' && verifierTypeEntite(p->nomIdf,"Chaine") != 0) {
                printf ("erreur semantique a la ligne %d : non compabilite de type %s n'est pas une Chaibe \n",nb_ligne,p->nomIdf);
            }
            p = p->next;
            i++;
        }
    
} | mc_out mc_parenthese_ouv mc_string mc_parenthese_fer pvg 
;

liste_idf: idf {
    
    strcpy (temp3,$1);
    if (doubleDeclaration($1)==0) {
        printf ("erreur semantique a la ligne %d : variable %s non declare \n",nb_ligne,temp3);
    }
    struct node *ptr;
        ptr=(struct node *) malloc(sizeof(struct node));
        strcpy (ptr->nomIdf, temp3);
        ptr->next =NULL;
        if(tete1==NULL) {
            tete1=ptr;
        }
        else {
            ptr->next=tete1;
            tete1=ptr;
        }
    
} | idf vrg liste_idf {
    strcpy (temp3,$1);
    if (doubleDeclaration($1)==0) {
        printf ("erreur semantique a la ligne %d : variable %s non declare \n",nb_ligne,temp3);
    }
     struct node *ptr;
        ptr=(struct node *) malloc(sizeof(struct node));
        strcpy (ptr->nomIdf, temp3);
        ptr->next =NULL;
        if(tete1==NULL) {
            tete1=ptr;
        }
        else {
            ptr->next=tete1;
            tete1=ptr;
        }
    } 
;
//----------------------------------------------------PARTIE AFFECTATION---------------------------------------------------------------

AFFECTATION: TYPE_IDEF mc_affectation EXPRESSION_ARITHMETIQUE pvg {
    
    if (biblang==0){printf ("erreur semantique a la ligne %d : bibliotheque ISIL.lang est non desponible\n",nb_ligne);}}
;

TYPE_IDEF: idf { strcpy (sauvIdf,$1);
	if (doubleDeclaration($1)==0) {
	printf ("erreur semantique a la ligne %d : variable non declare\n",nb_ligne);}
    if (verifierConstant($1)==0 && verifierValeur ($1)== -1) {
                    printf ("erreur semantique a la ligne %d : modification dune valeur dune constante\n",nb_ligne);
}
}
|idf_tableau mc_crochet_ouv cst mc_crochet_fer {
    if (biblang==0){printf ("erreur semantique a la ligne %d : bibliotheque ISIL.lang est non desponible\n",nb_ligne);}
    strcpy (sauvIdf,$1);
    sprintf (temp,"%d",$3);
    if (verifierTailleTableau ($1,temp) == -1){
        printf ("erreur semantique a la ligne %d : index out of bound \n",nb_ligne);
    }
}
;

EXPRESSION_ARITHMETIQUE: EXPRESSION_ARITHMETIQUE OPERATION X{
    
if((strcmp(sauvOpr,"/")==0)&&(sauvCst==0)){
    printf("erreur semantique a la ligne %d : Division sur zero\n",nb_ligne);
}

if((strcmp(sauvOpr,"/")==0)&&(strcmp(valcst,"0")==0)) {
    printf("erreur semantique a la ligne %d : Division sur zero\n",nb_ligne);
}

if((strcmp(sauvOpr,"/")==0)&&(verifierTypeEntite(sauvIdf,"Entier")==0)){ 
    printf ("erreur semantique a la ligne %d : Non compatibilite de type %s est un Entier mais il recoit un Reel\n",nb_ligne,sauvIdf);
}
}

|X
;

OPERATION: mc_multiplication { strcpy(sauvOpr,$1);}
			|mc_addition{ strcpy(sauvOpr,$1);}
			|mc_division{ strcpy(sauvOpr,$1);}
			|mc_soustraction{ strcpy(sauvOpr,$1);}
;

X : idf {
    if (doubleDeclaration($1)==0){
        printf ("erreur semantique a la ligne %d : variable %s non declare\n",nb_ligne,$1);
    }
    if(verifierConstant($1)==0){
	valeurcst($1,valcst);
	}
   if (compareType($1,sauvIdf) == -1) {
       printf ("erreur semantique a la ligne %d : Non compatibilite de type \n",nb_ligne);
}   

}
|cst {
    sauvCst = $1;
    if (verifierTypeEntite(sauvIdf,"Chaine")==0) {
       printf ("erreur semantique a la ligne %d : Non compatibilite de type %s est une chaine\n",nb_ligne,sauvIdf);
    } else {
      if ((verifierConstant (sauvIdf)==0) && (verifierValeur (sauvIdf) == 0)) {
        sprintf (temp,"%d",$1);
        insererValeur (sauvIdf,temp);
      } 
    }
}
|mc_string {
    
    if (verifierTypeEntite(sauvIdf,"Reel")==0 || verifierTypeEntite(sauvIdf,"Entier")==0) {
       printf ("erreur semantique a la ligne %d : Non compatibilite de type %s n'est pas une chaine \n",nb_ligne,sauvIdf);
    } else {
        if ((verifierConstant (sauvIdf)==0) && (verifierValeur (sauvIdf) == 0)) {
        insererValeur (sauvIdf,$1);
       } 
    }
    
}
| cst_e {
	if(verifierTypeEntite(sauvIdf,"Entier")==0 || verifierTypeEntite(sauvIdf,"Chaine")==0){
	    printf ("erreur semantique a la ligne %d : Non compatibilite de type %s n'est pas un Reel \n",nb_ligne,sauvIdf);
    } else {
        if ((verifierConstant (sauvIdf)==0) && (verifierValeur (sauvIdf) == 0)) {
        sprintf (temp,"%f",$1);
        insererValeur (sauvIdf,temp);
    } 
    }
}  
;


//------------------------------------------------PARTIE LECTURE-------------------------------------------------------------------------

LECTURE: mc_in mc_parenthese_ouv mc_string vrg idf mc_parenthese_fer pvg
{if (bibio == 0) {printf ("erreur semantique a la ligne %d : bibliotheque ISIL.io non disponible\n",nb_ligne);}
    if (doubleDeclaration($5) == 0) {
    printf ("erreur semantique a la ligne %d : variable non declarer \n",nb_ligne);
}
else {
    
    if ((strcmp($3,"\"%d\"")==0) && (verifierTypeEntite ($5,"Entier") != 0)){
        printf ("erreur semantique a la ligne %d : signe de formatage ou le nom de la variable \n",nb_ligne);
    }
    if ((strcmp($3,"\"%s\"")==0) && (verifierTypeEntite ($5,"Chaine") != 0)){
        printf ("erreur semantique a la ligne %d : signe de formatage ou le nom de la variable \n",nb_ligne);
    }
    if ((strcmp($3,"\"%f\"")==0) && (verifierTypeEntite ($5,"Reel") != 0)){
        printf ("erreur semantique a la ligne %d : signe de formatage ou le nom de la variable \n",nb_ligne);
    }
}
}
;



//----------------------------------------------- PARTIE DECLARATIONs----------------------------------------------------------------------------------
CORPS: LISTE_DECLARATION
;

LISTE_DECLARATION: DECLARATION LISTE_DECLARATION
                       |
;

DECLARATION: DECLARATION_VAR|DECLARATION_TABLEAU|DECLARATION_CONST
;


//------------------------------------------------- DECLARATION CONST -----------------------------------------------------------------------------
DECLARATION_CONST: mc_const TYPE idf mc_affectation cst pvg {
    if (biblang==0){printf ("erreur semantique a la ligne %d : bibliotheque ISIL.lang est non desponible\n",nb_ligne);}
    if(doubleDeclaration($3)==0) {
    insererType($3,sauvType);
    insererConstant($3,"oui");
    sprintf (temp,"%d",$5);
    insererValeur($3,temp);
    }
    else {
		printf("erreur semantique: double declaration a la ligne %d\n",nb_ligne);}}
| mc_const TYPE LISTE_IDF_CONST pvg 
;

LISTE_IDF_CONST: idf vrg LISTE_IDF_CONST {if(doubleDeclaration($1)==0) {
    insererType($1,sauvType);
    insererConstant($1,"oui");
     insererValeur($1,"/");
     }
 else {printf("erreur semantique: double declaration a la ligne %d\n",nb_ligne);}}
 | idf {if(doubleDeclaration($1)==0) {
        insererType($1,sauvType);
        insererConstant($1,"oui");
        insererValeur($1,"/");
        }
        else {printf("erreur semantique: double declaration a la ligne %d\n",nb_ligne);}}
;

//---------------------------------------------DECLARATION TABLEAU ------------------------------------------------------------------------------------

DECLARATION_TABLEAU:TYPE LISTE_IDF_TABLEAU pvg
;

LISTE_IDF_TABLEAU:idf_tableau mc_crochet_ouv cst mc_crochet_fer vrg LISTE_IDF_TABLEAU {if(doubleDeclaration($1)==0) {
    insererType($1,sauvType);
    insererConstant($1,"non");
    sprintf (temp,"%d",$3);
    insererTailleTableau ($1,temp);
    }
  else {
    printf("erreur semantique: double declaration a la ligne %d\n",nb_ligne);} 
    if($3<=0) {
    printf("erreur semantique a la ligne %d : un tableau ne pas pas etre de taille negative ou nulle\n", nb_ligne);}}
    | idf_tableau mc_crochet_ouv cst mc_crochet_fer { 
    if($3<=0) {printf("erreur semantique: un tableau ne pas pas etre de taille negative ou nulle a la ligne %d\n", nb_ligne);}
    if(doubleDeclaration($1)==0) {
    insererType($1,sauvType);
    insererConstant($1,"non");
    sprintf (temp,"%d",$3);
    insererTailleTableau ($1,temp);
}
  else {
    printf("erreur semantique: double declaration a la ligne %d\n",nb_ligne);}} 

;


//-----------------------------------------------DECLARATION VARIABLE ----------------------------------------------------------------------------------
DECLARATION_VAR: TYPE LISTE_IDF pvg
;

LISTE_IDF: idf vrg LISTE_IDF { if(doubleDeclaration($1)==0) {
    insererType($1,sauvType);
    insererConstant($1,"non"); 
    }
        else {printf("erreur semantique: double declaration a la ligne %d\n",nb_ligne);}}
        | idf { if(doubleDeclaration($1)==0) {
    insererType($1,sauvType); 
    insererConstant($1,"non");
    }
else { printf("erreur semantique: double declaration a la ligne %d\n",nb_ligne);}}
 
;

TYPE: mc_entier{strcpy(sauvType,"Entier");}|mc_reel{strcpy(sauvType,"Reel");}|mc_chaine{strcpy(sauvType,"Chaine");}
;

%%
main()
{yyparse();
afficher();
}

yywrap()
{}

yyerror (char*msg)
{
    printf ("erreur syntaxique a la ligne %d \n",nb_ligne);
}