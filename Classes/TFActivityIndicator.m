//
//  TFActivityIndicator.m
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import "TFActivityIndicator.h"


@implementation TFActivityIndicator

@synthesize spinner, label;
@dynamic text;

- (void)startAnimating {
	[self.spinner startAnimating];
}

- (void)stopAnimating {
	[self.spinner stopAnimating];
}

- (NSString *)text {
	return self.label.text;
}

- (void)setText:(NSString *)text {
	self.label.text = text;
}

+ (TFActivityIndicator *)activityIndicator {
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TFActivityIndicator" owner:nil options:nil];
	return [nib objectAtIndex:0];
}

- (void)dealloc {
	[spinner release];
	[label release];
	[super dealloc];
}


@end
