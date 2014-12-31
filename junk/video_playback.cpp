#include "opencv2/opencv.hpp"

using namespace cv;

int main(int, char**)
{
    VideoCapture cap("/Users/mallikarjun/Documents/action_recognition/datasets/hmdb51/brush_hair/sarah_brushing_her_hair_brush_hair_h_cm_np1_ri_goo_1.avi"); // open the default camera
    //VideoCapture cap("/Users/mallikarjun/Downloads/Sehwags 1st ODI Century - India vs New Zealand.mp4"); // open the default camera
    if(!cap.isOpened())  // check if we succeeded
        return -1;

    Mat edges;
    namedWindow("edges",1);
    for(;;)
    {
        Mat frame;
        cap >> frame; // get a new frame from camera
        cvtColor(frame, edges, COLOR_BGR2GRAY);
        GaussianBlur(edges, edges, Size(7,7), 1.5, 1.5);
        Canny(edges, edges, 0, 30, 3);
        imshow("edges", edges);
        if(waitKey(30) >= 0) break;
    }
    // the camera will be deinitialized automatically in VideoCapture destructor
    return 0;
}
