#include <stdio.h>


typedef long Align;

union header {
    struct {
        union header *ptr;
        unsigned size;
    } s;
    Align x;
};

typedef union header Header;


static Header base;
static Header *freep = NULL;
static Header *morecore(unsigned);

void* myalloc(unsigned nbytes)
{
    Header *p, *prevp;
    unsigned nunits;

    if ((prevp = freep) == NULL) {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    for (p = prevp->s.ptr; ; prevp = p, p = p->s.ptr) {
        if (p->s.size >= nunits) {
            if (p->s.size == nunits) {
                prevp->s.ptr = p->s.ptr;
            } else {
                p->s.size -= nunits;
                p += p->s.size;
                p->s.size = nunits;
            }
            freep = prevp;
            return (void*)(p+1);
        }

        if (p == freep) {
            if ((p = morecore(nunits)) == NULL)
                return NULL;
        }
    }
}


void myfree(void *ap)
{
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;

    if (bp + bp->s.size == p->s.ptr) {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    } else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp) {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    } else
        p->s.ptr = bp;
    freep = p;
}


#define NALLOC 1024

static Header* morecore(unsigned nu)
{
    char *cp, *sbrk(int);
    Header *up;

    if (nu < NALLOC)
        nu = NALLOC;
    cp = sbrk(nu * sizeof(Header));
    if (cp == (char*) -1)
        return NULL;
    up = (Header*) cp;
    up->s.size = nu;
    myfree((void*)(up+1));
    return freep;
}


int main()
{
    int *ptr = (int*)myalloc(sizeof(int));
    *ptr = 5;

    printf("Got int [%d] at [%p]\n", *ptr, ptr);

    myfree(ptr);

    return 0;
}