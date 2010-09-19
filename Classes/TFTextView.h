//
//  TFTextView.h
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//
#import <UIKit/UIKit.h>

@class TFTextView;

@protocol TFTextViewDelegate
- (void)textViewDidBecomeFirstResponder:(TFTextView *)textView;
- (void)textViewDidResignFirstResponder:(TFTextView *)textView;
@end

/**
 * An extension of the UITextView class that adds a special delegate that will be
 * notified when the text view becomes the first responder, or resigns those 
 * responsibilities
 */
@interface TFTextView : UITextView {
	id<TFTextViewDelegate> responderDelegate;
}

@property (nonatomic, assign) id<TFTextViewDelegate> responderDelegate;

@end
