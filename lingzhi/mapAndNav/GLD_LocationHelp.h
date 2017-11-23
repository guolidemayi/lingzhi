//
//  GLD_LocationHelp.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/23.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationPlacemark)(CLPlacemark *placemark);
typedef void(^LocationFailed)(NSError *error);
typedef void(^LocationStatus)(CLAuthorizationStatus status);


@interface GLD_LocationHelp : NSObject


+ (instancetype)sharedInstance;



- (void)getLocationPlacemark:(LocationPlacemark)placemark status:(LocationStatus)status didFailWithError:(LocationFailed)error;


@end
