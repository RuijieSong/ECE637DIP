#include <math.h>
#include "tiff.h"
#include "allocate.h"
#include "randlib.h"
#include "typeutil.h"

struct pixel {
    int m,n; /* m=row, n=col */
}

void ConnectedNeighbors(
    struct pixel s,
    double T, /* threshold*/
    unsigned char **img, /* 2D array of pixels */
    int width,
    int height,
    int *M, /* a pointer to the number of neighbors connected to the pixel s */
    struct pixel c[4]); /* This is an array containing the M connected neighbors to the pixel s. */
{
    if ((s.m > height) || (s.n > width)) {
        print "error, the pixel s exceeds the width & height of the image"
    }
    *M = 0;
    if ((s.m-1)>=0) && (abs(**img[m][n] - **img[m-1][n])<=T) {
        c[*M].m = s.m - 1;
        c[*M].n = s.n;
        *M = *M + 1;
    }
    if ((s.m+1)>=0) && (abs(**img[m][n] - **img[m-1][n])<=T) {
        c[*M].m = s.m + 1;
        c[*M].n = s.n;
        *M = *M + 1;
    }
    if ((s.n-1)>=0) && (abs(**img[m][n] - **img[m-1][n])<=T) {
        c[*M].n = s.n - 1;
        c[*M].m = s.m;
        *M = *M + 1;
    }
    if ((s.n+1)>=0) && (abs(**img[m][n] - **img[m-1][n])<=T) {
        c[*M].n = s.n + 1;
        c[*M].m = s.m;
        *M = *M + 1;
    }
}

    // int Yr[height][width];
    // int i;
    // int j;
    // for ( i = 0; i < height; i++ ) {
    //     for ( j = 0; j < width; j++ ) {
    //         Yr[i][j] = 0;
    //     }
    // }

void ConnectedSet(
    struct pixel s,
    double T,
    unsigned char **img,
    int width,
    int height,
    int ClassLabel, /* s the integer value that will be used to label any pixel which is connected to s. */
    unsigned int **seg,
    int *NumConPixels) /* the number of pixels which were found to be connected to s. */
{
    // Doing recursive is simpler than link-list (idea from Piazza)
    ConnectedSet(s,T,img,w,h,ClassLabel,seg,NumConPixels){
        M=0;
        *NumConPixels+=1
        seg[s.m][s.n]=1;
        ConnectedNeighbors(s,T,img,w,h,&M,c);
        //base case:
        if(M==0){return;}//no neighbors
        if(seg[c[i].m][c[i].n]==1 for all i in range(M)){return;} //all neighbors already visited
        else{
            for(i=0;i<M;i++){//recursion
            ConnectedNeighbors(c[i],T,img,w,h,ClassLabel,seg,NumConPixels);}
        }
    }  
}

int main (int argc, char **argv) 
{
  FILE *fp;
  struct TIFF_img input_img;

  /* accepts a command line argument specifying the value of rho */
  // scanf("%lf", &rho);

  if ( argc != 2 ) error( argv[0] );

  /* open image file */
  if ( ( fp = fopen ( argv[1], "rb" ) ) == NULL ) {
    fprintf ( stderr, "cannot open file %s\n", argv[1] );
    exit ( 1 );
  }

  /* read image */
  if ( read_TIFF ( fp, &input_img ) ) {
    fprintf ( stderr, "error reading file %s\n", argv[1] );
    exit ( 1 );
  }

  /* close image file */
  fclose ( fp );
}