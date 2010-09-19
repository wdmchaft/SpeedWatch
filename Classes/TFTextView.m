//
//  TFTextView.m
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import "TFTextView.h"


@implementation TFTextView

@synthesize responderDelegate;

- (BOOL)becomeFirstResponder {
	if (self.responderDelegate) {
		[responderDelegate textViewDidBecomeFirstResponder:self];
	}
	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	if (self.responderDelegate) {
		[responderDelegate textViewDidResignFirstResponder:self];
	}
	return [super resignFirstResponder];
}

@end