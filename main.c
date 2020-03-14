#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#define HASH_MULTIPLIER 65599
#define SIZE 509

int step=100;
/* Return a hash code for name. */
static unsigned int SymTable_hash(const char *name)
{
    size_t ui;
    unsigned int uiHash;
    uiHash = 0U;
    for (ui = 0U; name[ui] != '\0'; ui++)
    uiHash = uiHash * HASH_MULTIPLIER + name[ui];
    return uiHash%SIZE;
}

struct ArgFunction
{
    char* name;
    struct ArgFunction* next;
};

struct SymTableEntry
{
    const char *name;
    char* type;
    unsigned int scope;
    unsigned int line;
    int isActive;
    struct SymTableEntry* nextScopeList;
    struct SymTableEntry* next;
};

struct SymTable
{
    struct SymTableEntry** head;
    unsigned int size;
};



struct SymTable* SymTable_new(int size)
{
    int i=0;
    struct SymTable* node= malloc(sizeof(struct SymTable));
    node->head=malloc(size*sizeof(struct SymTableEntry*));
    for (i=0;i<size;i++) node->head[i]=NULL;
    node->size=0;
    return  node;
}

struct SymTable* ScopeTable;

struct SymTable* insertNodeToScope(struct SymTable* root,struct SymTableEntry *node,int scope)
{
    if(step<=scope)
    {

        step=2*step;
        printf("step:%d\nscope:%d",step,scope);
        //ScopeTable = (struct SymTable*)realloc(ScopeTable, sizeof(struct SymTable));
        ScopeTable->head=(struct SymTableEntry**)realloc(ScopeTable->head,step*sizeof(struct SymTableEntry*));
    }
    struct SymTableEntry *tmp=root->head[scope];
    node->nextScopeList=tmp;
    root->head[scope]=node;
    return root;
}


struct SymTable* insertNodeToHash(struct SymTable* root,const char* name,char* type,unsigned int scope,unsigned int line,int isActive)
{
    unsigned int position= SymTable_hash(name);
    struct SymTableEntry *tmp=root->head[position];
    struct SymTableEntry *node=(struct SymTableEntry*)malloc(sizeof(struct SymTableEntry));

    assert(root);
    assert(name);
    assert(node);

    node->name=strdup(name);
    node->type=strdup(type);
    node->scope=scope;
    node->line=line;
    node->isActive=isActive;

    node->next=tmp;
    root->head[position]=node;

    ScopeTable=insertNodeToScope(ScopeTable,node,node->scope);

    root->size++;
    return root;
}


void Hide(struct SymTable* root,int scope)
{
    struct SymTableEntry *tmp=root->head[scope];
    while(tmp)
    {
        tmp->isActive=0;
        tmp=tmp->nextScopeList;
    }
    return;
}

void printHash(struct SymTable* root)
{
    struct SymTableEntry* tmp;
    int i;
    for(i=0;i<SIZE;i++)
    {
        tmp=root->head[i];

        if(root->head[i]==NULL)
            continue;
        printf("index%d:",i);
        while(tmp)
        {
            if(tmp != root->head[i])
                printf(",");
            printf("<%s, %s, %d, %d, %d>",tmp->name,tmp->type,tmp->scope,tmp->line,tmp->isActive);
            tmp=tmp->next;
        }
        printf("\n");
    }
}

void printScopeTable(struct SymTable* ScopeTable)
{
    struct SymTableEntry* tmp;
    int i;
    for(i=0;i<step;i++)
    {
        tmp=ScopeTable->head[i];

        if(ScopeTable->head[i]==NULL)
            continue;
        printf("index%d:",i);
        while(tmp)
        {
            if(tmp != ScopeTable->head[i])
                printf(",");
            printf("<%s, %s, %d, %d, %d>",tmp->name,tmp->type,tmp->scope,tmp->line,tmp->isActive);
            tmp=tmp->nextScopeList;
        }
        printf("\n");
    }
}

int NameLookUpInHash(struct SymTable* root,const char* name)
{
    struct SymTableEntry* tmp;
    for(int i=0;i<SIZE;i++)
    {
        tmp=root->head[i];
        if(root->head[i]==NULL)
            continue;
        while(tmp)
        {
            if(tmp->isActive==1 && strcmp(name, tmp->name)==0)
                return 1;
            tmp=tmp->next;
        }
    }
    return 0;
}

int NameLookUpInScope(struct SymTable* root,unsigned int scope,const char* name)
{
    struct SymTableEntry *tmp=root->head[scope];
    while(tmp)
    {
        if(tmp->isActive==1 && strcmp(name, tmp->name)==0)
            return 1;
        tmp=tmp->nextScopeList;
    }
    return 0;
}

int main()
{
    struct SymTable* Head=SymTable_new(509);
    ScopeTable=SymTable_new(100);
    Head=insertNodeToHash(Head,"x","local",0,1,1);
    Head=insertNodeToHash(Head,"x","global",0,5,1);
    Head=insertNodeToHash(Head,"print","funLib",1,2,1);
    Head=insertNodeToHash(Head,"if","funLib",1,2,1);
    Head=insertNodeToHash(Head,"if","funLib",2,2,1);
    //printf("Hello world!\n");
    printHash(Head);
    printf("\n\n");
    printScopeTable(ScopeTable);
    Hide(ScopeTable,1);
    printf("\n\n");
    printScopeTable(ScopeTable);
    printf("\n\n");
    printHash(Head);
    printf("\n\n");
    printf("%d",NameLookUpInScope(ScopeTable,0,"x"));
    printf("\n\n");
    printHash(Head);
    printf("\n\n-------------");

    /*Head=insertNodeToHash(Head,"y","local",150,2,1);
    printHash(Head);
    printf("\n\n");
    printScopeTable(ScopeTable);
    printf("\n\n");
    Head=insertNodeToHash(Head,"k","local",250,2,1);
    printHash(Head);
    printf("\n\n");
    printScopeTable(ScopeTable);
    printf("\n\n");
    Head=insertNodeToHash(Head,"k","local",567,2,1);
    printHash(Head);
    printf("\n\n");
    printScopeTable(ScopeTable);*/
    return 0;
}
