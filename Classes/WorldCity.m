//
//  WorldCity.m
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import "WorldCity.h"

@implementation WorldCity

@synthesize name, latitude, longitude;

// Implementing this method ensures the Key-Value observers will be notified when the properties
// from which coordinate is derived have changed.
//
+ (NSSet *)keyPathsForValuesAffectingCoordinate
{
    return [NSSet setWithObjects:@"latitude", @"longitude", nil];
}

// derive the coordinate property.
- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self.latitude.doubleValue;
    coordinate.longitude = self.longitude.doubleValue;
    return coordinate;
}

@end