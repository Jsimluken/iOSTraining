//
//  OpenCVWrapper.h
//  opencv_test
//
//  Created by Michael Laurents on 2019/11/02.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject
    +(NSString *) versionNumber;
    +(UIImage *) convertToGrayscale: (UIImage *) image;
    +(UIImage *) faceDetect: (UIImage *) image;
@end

NS_ASSUME_NONNULL_END
