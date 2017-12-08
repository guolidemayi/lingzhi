//
//  MKMapView+ZoomLevel.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/7.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
