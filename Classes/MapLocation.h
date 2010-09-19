//
//  MapLocation.h
//  LocateMe
//  A data model
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject <MKAnnotation, NSCoding> 
{ 
	NSString *streetAddress; 
	NSString *city; 
	NSString *state;
	NSString *zip; 
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *streetAddress; 
@property (nonatomic, copy) NSString *city; 
@property (nonatomic, copy) NSString *state; 
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end