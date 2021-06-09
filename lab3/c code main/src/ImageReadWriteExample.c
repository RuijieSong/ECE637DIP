/* ------------------------SECTION 2----------------------*/
#include <math.h>
#include "tiff.h"
#include "allocate.h"
#include "randlib.h"
#include "typeutil.h"
#include <stdio.h>

void error(char *name);

struct pixel {
    int m,n; /* m=row, n=col */
};

void ConnectedNeighbors(
    struct pixel s,
    double T, /* threshold*/
    unsigned char **img, /* 2D array of pixels */
    int width,
    int height,
    int *M, /* a pointer to the number of neighbors connected to the pixel s */
    struct pixel c[4]); /* This is an array containing the M connected neighbors to the pixel s. */

void ConnectedSet(
    struct pixel s,
    double T,
    unsigned char **img,
    int width,
    int height,
    int ClassLabel, /* s the integer value that will be used to label any pixel which is connected to s. */
    uint8_t **seg,
    int *NumConPixels); /* the number of pixels which were found to be connected to s. */

int main (int argc, char **argv) 
{   
    // Define parameters
    FILE *fp;
    struct TIFF_img input_img, color_img, segmentation;
    // struct pixel s;
    // s.m = 45;
    // s.n = 67;
    double T = 3.0;
    int ClassLabel = 1;
    int NumConPixels = 0;
    int NOR = 0;

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

    /* check the type of image data */
    if ( input_img.TIFF_type != 'g' ) {
    fprintf ( stderr, "error:  image must be 24-bit color\n" );
    exit ( 1 );
    }

    /* set up structure for output color image */
    /* Note that the type is 'g' rather than 'c' */
    get_TIFF ( &color_img, input_img.height, input_img.width, 'g' );

    // printf("reading success\n");

    /* create a 2D matrix to record segmentations */
    get_TIFF ( &segmentation, input_img.height, input_img.width, 'g' );

    /* Initialize the Output */
    int i;
    int j;
    for ( i = 0; i < input_img.height; i++ ) {
        for ( j = 0; j < input_img.width; j++ ) {
            color_img.mono[i][j] = 0;
        }
    }

    /* Initialize the segmentations */
    for ( i = 0; i < input_img.height; i++ ) {
        for ( j = 0; j < input_img.width; j++ ) {
            segmentation.mono[i][j] = 0;
        }
    }

    // printf("output init success\n");

    i = 0;
    j = 0;
    int ii = 0; int jj = 0;
    for ( i = 0; i < input_img.height; i++ ) {
        for ( j = 0; j < input_img.width; j++ ) {
            struct pixel s;
            s.m = i;
            s.n = j;
            if (color_img.mono[i][j] == 0) {
                ConnectedSet(
                    s,
                    T,
                    input_img.mono,
                    input_img.width,
                    input_img.height,
                    ClassLabel, /* s the integer value that will be used to label any pixel which is connected to s. */
                    segmentation.mono,
                    &NumConPixels); /* the number of pixels which were found to be connected to s. */
                // printf("%d\n", NumConPixels);
                if (NumConPixels > 100) {
                    NOR = NOR + 1;
                    ClassLabel = ClassLabel + 1;
                    for ( ii = 0; ii < input_img.height; ii++ ) {
                        for ( jj = 0; jj < input_img.width; jj++ ) {
                            color_img.mono[ii][jj] = segmentation.mono[ii][jj] + color_img.mono[ii][jj];
                        }
                    }
                    ii = 0; jj = 0;
                }
            for ( ii = 0; ii < input_img.height; ii++ ) {
                for ( jj = 0; jj < input_img.width; jj++ ) {
                         segmentation.mono[ii][jj] = 0;
                }
            }
            NumConPixels = 0;
            }
        }
    }

    printf("%d\n", NOR);

    // printf("process success\n");

    // i = 0;
    // j = 0;
    // for ( i = 0; i < input_img.height; i++ ) {
    //     for ( j = 0; j < input_img.width; j++ ) {
    //         if (color_img.mono[i][j] == 0) {
    //             color_img.mono[i][j] = 255;
    //         }
    //         else {
    //             color_img.mono[i][j] = 0;
    //         }
    //     }
    // }

    /* open color image file */
    if ( ( fp = fopen ( "color.tif", "wb" ) ) == NULL ) {
        fprintf ( stderr, "cannot open file color.tif\n");
        exit ( 1 );
    }

    /* write color image */
    if ( write_TIFF ( fp, &color_img ) ) {
        fprintf ( stderr, "error writing TIFF file %s\n", argv[2] );
        exit ( 1 );
    }

    /* close color image file */
    fclose ( fp );

    /* de-allocate space which was used for the images */
    free_TIFF ( &(input_img) );
    free_TIFF ( &(color_img) );

    return(0);
}

void error(char *name)
{
    printf("usage:  %s  image.tiff \n\n",name);
    printf("this program reads in a 24-bit color TIFF image.\n");
    printf("It then horizontally filters the green component, adds noise,\n");
    printf("and writes out the result as an 8-bit image\n");
    printf("with the name 'green.tiff'.\n");
    printf("It also generates an 8-bit color image,\n");
    printf("that swaps red and green components from the input image");
    exit(1);
}

void ConnectedNeighbors(
    struct pixel s,
    double T, /* threshold*/
    unsigned char **img, /* 2D array of pixels */
    int width,
    int height,
    int *M, /* a pointer to the number of neighbors connected to the pixel s */
    struct pixel c[4]) /* This is an array containing the M connected neighbors to the pixel s. */
{
    if ((s.m > height) || (s.n > width)) {
        printf("error, the pixel s exceeds the width & height of the image\n");
    }
    // *M = 0;
    if (((s.m-1)>=0) && (abs(img[s.m][s.n] - img[s.m-1][s.n])<=T)) {
        c[*M].m = s.m - 1;
        c[*M].n = s.n;
        *M = *M + 1;
        // printf("1 \n");
    }
    if (((s.m+1)<=height-1) && (abs(img[s.m][s.n] - img[s.m+1][s.n])<=T)) {
        c[*M].m = s.m + 1;
        c[*M].n = s.n;
        *M = *M + 1;
        // printf("2 \n");
    }
    if (((s.n-1)>=0) && (abs(img[s.m][s.n] - img[s.m][s.n-1])<=T)) {
        c[*M].n = s.n - 1;
        c[*M].m = s.m;
        *M = *M + 1;
        // printf("3 \n");
    }
    if (((s.n+1)<=width-1) && (abs(img[s.m][s.n] - img[s.m][s.n+1])<=T)) {
        c[*M].n = s.n + 1;
        c[*M].m = s.m;
        *M = *M + 1;
        // printf("4 \n");
    }
    return;
}

void ConnectedSet(
    struct pixel s,
    double T,
    unsigned char **img,
    int width,
    int height,
    int ClassLabel, /* s the integer value that will be used to label any pixel which is connected to s. */
    uint8_t **seg,
    int *NumConPixels) /* the number of pixels which were found to be connected to s. */
{

    // printf("processing started\n");
    
    int M = 0;
    *NumConPixels = *NumConPixels + 1;
    struct pixel c[4];
    int i=0;
    
    // printf("piazza code starts\n");
    seg[s.m][s.n]=ClassLabel;    
    // Doing recursive is simpler than link-list (idea from Piazza)
    ConnectedNeighbors(s,T,img,width,height,&M,c);
    //base case:
    if(M==0){return;}//no neighbors
    // if(seg[c[i].m][c[i].n]==1 for all i in range(M)){return;} //all neighbors already visited
    for(i=0;i<M;i++){
        if(seg[c[i].m][c[i].n]!=ClassLabel) {
            ConnectedSet(c[i],T,img,width,height,ClassLabel,seg,NumConPixels);
        }
        else{
            continue;
        }
    }
    return;
}