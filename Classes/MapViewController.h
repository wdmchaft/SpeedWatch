//
//  MapViewController.h
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <MapKit/MapKit.h> 
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKReverseGeocoderDelegate, MKMapViewDelegate, UIAlertViewDelegate> 
{
	MKMapView		*mapView; 
	UIProgressView  *progressBar;
	UILabel			*progressLabel;
	UIButton		*button;
	   
} 

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar; 
@property (nonatomic, retain) IBOutlet UILabel *progressLabel; 
@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction)findMe; 

@end