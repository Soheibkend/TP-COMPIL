
#include <stdlib.h>

struct element
{
char NomEntite[20];
char CodeEntite[20];
char TypeEntite[20];
char tailleTableau[20];
char valeur[20];
char constant[5];
struct element *next;
};

struct element *tete = NULL;

void desplay1 (){
	struct element *ptr = NULL;
	ptr = tete;
	while (ptr != NULL) {
		printf ("%s       %s      %s\n",ptr->NomEntite,ptr->TypeEntite,ptr->CodeEntite);
        ptr = ptr->next;
	}
}


struct element* recherche (char entite[]){
    struct element *ptr;
	if (tete == NULL) {
		return NULL;
	}
		ptr = tete;
		while (ptr != NULL) {
			if (strcmp (entite,ptr->NomEntite)==0){
				return ptr;
			}
			ptr = ptr->next;
		}
    return NULL;
}

void inserer(char entite[], char code[]) {

	if ( recherche(entite)== NULL) {
	    struct element *temp = NULL,*ptr = NULL;
        temp = (struct element *) malloc(sizeof (struct element));
		strcpy(temp->NomEntite,entite);
		strcpy(temp->CodeEntite,code);
		strcpy (temp->TypeEntite,"");
		strcpy (temp->tailleTableau,"");
		strcpy (temp->valeur,"");
		strcpy (temp->constant,"");
        temp->next = NULL;
        if(tete == NULL) {
            tete = temp;
        }
        else {
            ptr = tete;
            while(ptr->next != NULL) {
                ptr=ptr->next ;
            }
            ptr->next =temp;
        }
	}
	
}

void afficher () {

    struct element *ptr;
	ptr = tete;
	printf("\n/***************Table des symboles ******************/\n");
	printf("___________________________________________________________________________________________________\n");
	printf("\t| NomEntite |  CodeEntite | TyepEntite      | constant   |   valeur   |  tailleTableau   \n");
	printf("__________________________________________________________________________________________________\n");
	while(ptr != NULL) {
		printf("\t|%10s |%12s | %12s  | %12s | %12s | %12s \n",ptr->NomEntite,ptr->CodeEntite,ptr->TypeEntite,ptr->constant,ptr->valeur,ptr->tailleTableau);
		ptr = ptr->next;
	}
}

void insererValeur (char entite[], char val[]) {
	struct element *ptr = NULL;
	ptr=recherche(entite);
	if(ptr != NULL) {
	strcpy(ptr->valeur,val); 
    }
}

void insererTailleTableau (char entite[], char taille[]) {
	struct element *ptr = NULL;
	ptr = recherche(entite);
	if(ptr!= NULL) {
	strcpy(ptr->tailleTableau,taille);
	
    }
}

void insererConstant (char entite[], char cons[]) {
	struct element *ptr = NULL;
	ptr = recherche(entite);
	if(ptr != NULL) {
	strcpy(ptr->constant,cons); 
    }
}

void insererType(char entite[], char type[]) {
    struct element *ptr = NULL;
	ptr=recherche(entite);
	if(ptr != NULL) {
	strcpy(ptr->TypeEntite,type); 
    }
}

int doubleDeclaration(char entite[]) {

	struct element *ptr = NULL;
	ptr=recherche(entite);
	if (ptr != NULL) {
	if(strcmp(ptr->TypeEntite,"")==0){
       return 0; 
    } else {
       return -1;
    }	
    }
    return -1;
}

int verifierTypeEntite (char entite[], char type[]){
	struct element *ptr = NULL;
	ptr = tete;
    while (ptr != NULL) {
        if (strcmp(entite,ptr->NomEntite)==0) {
			return strcmp(type,ptr->TypeEntite);
        }
        ptr = ptr->next;
    }
	return -1;
}

int verifierTailleTableau (char entite[],char taille[]) {
	struct element *ptr = NULL;
	ptr = tete;
    while (ptr != NULL) {
        if (strcmp(entite,ptr->NomEntite)==0) {
			if(strcmp(taille,ptr->tailleTableau) == -1) {
                    return 0;
			}
        }
        ptr = ptr->next;
    }
	return -1;
}

int verifierConstant (char entite[]) {
	struct element *ptr = NULL;
	ptr = tete;
    while (ptr != NULL) {
        if (strcmp(entite,ptr->NomEntite)==0) {
			if(strcmp(ptr->constant,"oui") == 0) {
                    return 0;
			}
        }
        ptr = ptr->next;;
    }
	return -1;
}

int verifierValeur (char entite[]){
	struct element *ptr = NULL;
	ptr = tete;
    while (ptr != NULL) {
        if (strcmp(entite,ptr->NomEntite)==0) {
			if(strcmp(ptr->valeur,"/") == 0) {
                    return 0;
			}
        }
        ptr = ptr->next;
    }
	return -1;
}

int compareType (char entite1[], char entite2[]) {
	struct element *ptr = NULL;
	ptr = tete;
	char type1[5];
	char type2[5];
	while (ptr != NULL) {
		if (strcmp(entite1,ptr->NomEntite)==0) {
            strcpy(type1,ptr->TypeEntite);
		}
		if (strcmp(entite2,ptr->NomEntite)==0) {
            strcpy(type2,ptr->TypeEntite);
		}
        ptr = ptr->next;
	}

	if (strcmp (type1,type2)==0) {
		return 0;
	}
	return -1;

}

void afficherliste(char liste[]) {
	int i;
	for(i=0; i < strlen(liste) ; i++)
	{
		printf ("%c\t",liste[i]);
		
	}
	printf("\n");
	
}

int nombreLigneCommentaire (char texte[]) {
	int nombre = 0;
	int i = 0;
	for (i= 0 ; i < strlen (texte) ; i++) {
		if (texte[i] == '\n') {
			nombre++;
		}
	}
	return nombre;
} 

void valeurcst(char entite[], char val[]){
	
	struct element *ptr = NULL;
	ptr = tete;
    while (ptr != NULL) {
        if (strcmp(entite,ptr->NomEntite)==0) {
			if(verifierConstant(ptr->NomEntite)==0){
					strcpy(val,ptr->valeur);
			}
	    }
	    ptr = ptr->next;
	}		
}



