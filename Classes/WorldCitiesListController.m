//
//  WorldCitiesListController.m
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import "WorldCitiesListController.h"
#import "WorldCity.h"

@implementation WorldCitiesListController

@synthesize cityList, delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // load our data from a plist file inside our app bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
    NSArray *cities = [NSArray arrayWithContentsOfFile:path];
    
    self.cityList = [[[NSMutableArray alloc] initWithCapacity:[cities count]] autorelease];
	
    NSDictionary *city;
    for (city in cities)
    {
        WorldCity *newCity = [[WorldCity alloc] init];
        newCity.name = [city objectForKey:@"cityNameKey"];
        newCity.latitude = [city objectForKey:@"latitudeKey"];;
        newCity.longitude = [city objectForKey:@"longitudeKey"];
        
        [self.cityList addObject:newCity];
        [newCity release];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view methods

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cityList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kPlacesCellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlacesCellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPlacesCellIdentifier] autorelease];
        cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    WorldCity *worldCity = [self.cityList objectAtIndex:indexPath.row];
    cell.textLabel.text = worldCity.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.3f, %.3f", worldCity.coordinate.latitude, worldCity.coordinate.longitude];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate worldCitiesListController:self didChooseWorldCity:[self.cityList objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
	[cityList release];
    
    [super dealloc];
}

@end


