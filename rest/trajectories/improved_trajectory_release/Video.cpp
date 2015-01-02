#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <ctype.h>
#include <unistd.h>

#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <fstream>
#include <iostream>
#include <vector>
#include <list>
#include <string>

IplImage* image = 0; 
IplImage* prev_image = 0;
CvCapture* capture = 0;

int show = 1; 

int main( int argc, char** argv )
{
	int frameNum = 0;

    printf("Debug 00\n");
	char* video = argv[1];
    printf("Debug 11 %s \n",argv[1]);
	capture = cvCreateFileCapture(video);

	if( !capture ) { 
		printf( "Could not initialize capturing..\n" );
		return -1;
	}
	
	if( show == 1 )
		cvNamedWindow( "Video", 0 );

	while( true ) {
		IplImage* frame = 0;
		int i, j, c;

		// get a new frame
		frame = cvQueryFrame( capture );
		if( !frame ) {
			printf("debug 0");
			break;
		}

		if( !image ) {
			printf("debug 1");
			image =  cvCreateImage( cvSize(frame->width,frame->height), 8, 3 );
			image->origin = frame->origin;
		}

		cvCopy( frame, image, 0 );

		if( show == 1 ) {
			printf("debug 2");
			cvShowImage( "Video", image);
			c = cvWaitKey(3);
			if((char)c == 27) break;
		}
		
		std::cerr << "The " << frameNum << "-th frame" << std::endl;
		frameNum++;
	}

	if( show == 1 )
		cvDestroyWindow("Video");

	return 0;
}
