//
//  TFActivityIndicator.h
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface TFActivityIndicator : UIView {
	UIActivityIndicatorView *spinner;
	UILabel *label;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) NSString *text;

- (void)startAnimating;
- (void)stopAnimating;

+ (TFActivityIndicator *)activityIndicator;

@end