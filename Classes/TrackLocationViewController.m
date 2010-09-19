/*
     File: TrackLocationViewController.m
 Abstract: Attempts to track the user location with a specific level of accuracy. A "distance filter" indicates the smallest change in location that triggers an update from the location manager to its delegate. Presents a SetupViewController instance so the user can configure the desired accuracy and distance filter. Uses a LocationDetailViewController instance to drill down into details for a given location measurement.
 
  Version: 2.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "TrackLocationViewController.h"
#import "LocationDetailViewController.h"
#import "CLLocation (Strings).h"
#include <HTTPRiot/HTTPRiot.h>

@implementation TrackLocationViewController

@synthesize startButton;
@synthesize descriptionLabel;
@synthesize locationManager;
@synthesize locationMeasurements;
@synthesize tableView;
@synthesize stateString;

- (void)viewDidLoad {
    self.locationMeasurements = [NSMutableArray array];
}

/*
 * The view hierarchy for this controller has been torn down. This usually happens in response to low memory notifications.
 * All IBOutlets should be released by setting their property to nil in order to free up as much memory as possible. 
 * This is also a good place to release other variables that can be recreated when needed.
 */
- (void)viewDidUnload {
    self.startButton = nil;
    self.descriptionLabel = nil;
    self.stateString = nil;
    self.tableView = nil;
    // For the readonly properties, they must be released and set to nil directly.
    [setupViewController release];
    setupViewController = nil;
    [dateFormatter release];
    dateFormatter = nil;
}

- (void)dealloc {
    [stateString release];
    [descriptionLabel release];
    [dateFormatter release];
    [locationManager release];
    [startButton release];
    [setupViewController release];
    [locationMeasurements release];
    [tableView release];
    [locationDetailViewController release];
    [super dealloc];
}

/*
 * The lazy "getter" for the readonly property.
 */
- (SetupViewController *)setupViewController {
    if (setupViewController == nil) {
        setupViewController = [[SetupViewController alloc] initWithNibName:@"TrackLocationSetupView" bundle:nil];
        setupViewController.delegate = self;
    }
    return setupViewController;
}

/*
 * The lazy "getter" for the readonly property.
 */
- (LocationDetailViewController *)locationDetailViewController {
    if (locationDetailViewController == nil) {
        locationDetailViewController = [[LocationDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return locationDetailViewController;
}

/*
 * The lazy "getter" for the readonly property.
 */
- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    }
    return dateFormatter;
}

- (IBAction)start:(id)sender {
    [self.navigationController presentModalViewController:self.setupViewController animated:YES];
}

/* 
 * The reset method allows the user to repeatedly test the location functionality. In addition to discarding all of
 * the location measurements from the previous "run", it animates a transition in the user interface between the table
 * which displays location data and the start button and description label presented at launch.
 */
- (void)reset {
    [self.locationMeasurements removeAllObjects];
    [UIView beginAnimations:@"Reset" context:nil];
    [UIView setAnimationDuration:0.6];
    startButton.alpha = 1.0;
    descriptionLabel.alpha = 1.0;
    tableView.alpha = 0.0;
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];;
    [UIView commitAnimations];
}

#pragma mark Location Manager Interactions

/*
 * This method is invoked when the user hits "Done" in the setup view controller. The options chosen by the user are
 * passed in as a dictionary. The keys for this dictionary are declared in SetupViewController.h.
 */
- (void)setupViewController:(SetupViewController *)controller didFinishSetupWithInfo:(NSDictionary *)setupInfo {
    startButton.alpha = 0.0;
    descriptionLabel.alpha = 0.0;
    tableView.alpha = 1.0;
    // Create the manager object 
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    locationManager.desiredAccuracy = [[setupInfo objectForKey:kSetupInfoKeyAccuracy] doubleValue];
    // When "tracking" the user, the distance filter can be used to control the frequency with which location measurements
    // are delivered by the manager. If the change in distance is less than the filter, a location will not be delivered.
    locationManager.distanceFilter = [[setupInfo objectForKey:kSetupInfoKeyDistanceFilter] doubleValue];
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    self.stateString = NSLocalizedString(@"Tracking", @"Tracking");
    [self.tableView reloadData];
    UIBarButtonItem *resetItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"Reset") style:UIBarButtonItemStyleBordered target:self action:@selector(reset)] autorelease];
    [self.navigationItem setLeftBarButtonItem:resetItem animated:YES];;
}

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // store all of the measurements, just so we can see what kind of data we might receive
    [locationMeasurements addObject:newLocation];
    // update the display with the new location data
    [self.tableView reloadData];    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

- (void)stopUpdatingLocation:(NSString *)state {
    self.stateString = state;
    [self.tableView reloadData];
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

#pragma mark Table View DataSource/Delegate

// The table view has two sections. The first has 1 row which displays status information. The second has a row for each valid location object received from the location manager. 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return (self.locationMeasurements.count > 0) ? 2 : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return NSLocalizedString(@"Status", @"Status");
        } break;
        default: {
            return NSLocalizedString(@"All Measurements", @"All Measurements");
        } break;
    }
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 1;
        } break;
        default: {
            return locationMeasurements.count;
        } break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            // The cell for the status row uses the cell style "UITableViewCellStyleValue1", which has a label on the left side of the cell with left-aligned and black text; on the right side is a label that has smaller blue text and is right-aligned. An activity indicator has been added to the cell and is animated while the location manager is updating. The cell's text label displays the current state of the manager.
            static NSString * const kStatusCellID = @"StatusCellID";
            static NSInteger const kStatusCellActivityIndicatorTag = 2;
            UIActivityIndicatorView *activityIndicator = nil;
            UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:kStatusCellID];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kStatusCellID] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
                CGRect frame = activityIndicator.frame;
                frame.origin = CGPointMake(290, 12);
                activityIndicator.frame = frame;
                activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                activityIndicator.tag = kStatusCellActivityIndicatorTag;
                [cell.contentView addSubview:activityIndicator];
            } else {
                activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:kStatusCellActivityIndicatorTag];
            }
            cell.textLabel.text = stateString;
            if ([stateString isEqualToString:NSLocalizedString(@"Tracking", @"Tracking")]) {
                if (activityIndicator.isAnimating == NO) [activityIndicator startAnimating];
            } else {
                if (activityIndicator.isAnimating) [activityIndicator stopAnimating];
            }
            return cell;
        } break;
        default: {
            // The cells for the location rows use the cell style "UITableViewCellStyleSubtitle", which has a left-aligned label across the top and a left-aligned label below it in smaller gray text. The text label shows the coordinates for the location and the detail text label shows its timestamp.
            static NSString * const kOtherMeasurementsCellID = @"OtherMeasurementsCellID";
            UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:kOtherMeasurementsCellID];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kOtherMeasurementsCellID] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            CLLocation *location = [locationMeasurements objectAtIndex:indexPath.row];
            cell.textLabel.text = location.localizedCoordinateString;
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:location.timestamp];
            return cell;
        } break;
    }
}

// Delegate method invoked before the user selects a row. In this sample, we use it to prevent selection in the 
// first section of the table view.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? nil : indexPath;
}

// Delegate method invoked after the user selects a row. Selecting a row containing a location object
// will navigate to a new view controller displaying details about that location.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLLocation *location = [locationMeasurements objectAtIndex:indexPath.row];
    self.locationDetailViewController.location = location;
    [self.navigationController pushViewController:locationDetailViewController animated:YES];
}

@end
