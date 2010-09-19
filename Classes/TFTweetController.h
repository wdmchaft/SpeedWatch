//
//  TFTweetController.h
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFTextView.h"
#import "Limit.h"

@class TFTextEntryCell;
@class TFActivityIndicator;

@interface TFTweetController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, TFTextViewDelegate, LimitDelegate> {
	TFTextEntryCell *usernameCell;
	TFTextEntryCell *passwordCell;
	TFTextView *tweetText;
	TFActivityIndicator *activityIndicator;
	UIBarButtonItem *sendButton;
	UITableView *tableView;
	UILabel *counterLabel;
	NSString *initialText;
}

@property (nonatomic, retain) TFTextEntryCell *usernameCell;
@property (nonatomic, retain) TFTextEntryCell *passwordCell;
@property (nonatomic, retain) IBOutlet TFTextView *tweetText;
@property (nonatomic, retain) TFActivityIndicator *activityIndicator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *counterLabel;
@property (nonatomic, copy) NSString *initialText;

- (IBAction)cancelTweet:(id)sender;
- (IBAction)sendTweet:(id)sender;

- (id)initWithText:(NSString *)initialText;

@end
