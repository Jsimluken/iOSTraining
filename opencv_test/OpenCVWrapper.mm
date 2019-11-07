//
//  OpenCVWrapper.m
//  opencv_test
//
//  Created by Michael Laurents on 2019/11/02.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"


@implementation OpenCVWrapper

    +(NSString *) versionNumber
    {
        return [NSString stringWithFormat:@"OpenCV %s", CV_VERSION];
    }

    +(UIImage *) convertToGrayscale: (UIImage *) image
    {
        cv::Mat imageMat;
        UIImageToMat(image, imageMat);
        cv::Mat grayMat;
        NSLog(@"Test!!");
        //NSLog(@"Hyper!! %@",static_cast<void>(grayMat));
        cv::cvtColor(imageMat, grayMat,cv::COLOR_BGR2GRAY);
        
        // Convert to UImage
        return MatToUIImage(grayMat);
        //return image;
    }

    +(UIImage *) faceDetect: (UIImage *) image
    {
        cv::Mat colorMat;
        UIImageToMat(image, colorMat);
        
        cv::Mat grayMat;
        cv::cvtColor(colorMat, grayMat, cv::COLOR_BGR2GRAY);
        
        cv::CascadeClassifier classifier;
        const NSString* cascadePath = [[NSBundle mainBundle]
                                 pathForResource:@"haarcascade_frontalface_default"
                                 ofType:@"xml"];
        classifier.load([cascadePath UTF8String]);
        std::vector<cv::Rect> detections;
        const double scalingFactor = 1.1;
        const int minNeighbors = 2;
        const int flags = 0;
        const cv::Size minimumSize(300, 300);
        
        classifier.detectMultiScale(
                                    grayMat,
                                    detections,
                                    scalingFactor,
                                    minNeighbors,
                                    flags,
                                    minimumSize
                                    );
        
        // If no detections found, return nil
        if (detections.size() <= 0) {
            NSLog(@"No face!!");
            return MatToUIImage(grayMat);
        }

        // Range loop through detections
        for (auto &face : detections) {
            const cv::Point tl(face.x,face.y);
            const cv::Point br = tl + cv::Point(face.width, face.height);
            const cv::Scalar magenta = cv::Scalar(255, 0, 255);

            cv::rectangle(colorMat, tl, br, magenta, 4, 8, 0);
        }

        
        return MatToUIImage(colorMat);
    }

@end
