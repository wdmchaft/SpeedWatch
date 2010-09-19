//
//  TFTextEntryCell.h
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFTextEntryCell : UITableViewCell <UITextInputTraits> {
	UILabel *label;
	UITextField *textField;
	id<UITextFieldDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) id<UITextFieldDelegate> delegate;

- (NSString *)text;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;

@end
