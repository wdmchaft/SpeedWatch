//
//  WorldCitiesListController.h
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WorldCity.h"

@protocol WorldCitiesListControllerDelegate;

@interface WorldCitiesListController : UITableViewController <NSFetchedResultsControllerDelegate>
{
	NSMutableArray* cityList;
    
    id <WorldCitiesListControllerDelegate> delegate;
    BOOL addingNewPlace;
}

@property (nonatomic, retain) NSMutableArray* cityList;
@property (nonatomic, assign) id <WorldCitiesListControllerDelegate> delegate;

@end

@protocol WorldCitiesListControllerDelegate

- (void)worldCitiesListController:(WorldCitiesListController *)controller didChooseWorldCity:(WorldCity *)aPlace;

@end