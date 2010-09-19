//
//  TFTweetController.m
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//


#import "TFTweetController.h"
#import "TFTextEntryCell.h"
#import "TFActivityIndicator.h"

@interface TFTweetController (PrivateMethods)
- (TFTextEntryCell *)createCell;
- (void)checkText:(UITextView *)textView;
@end

static CGFloat kSlideAmount = 142;
static CGFloat kTableViewY = 44;

@implementation TFTweetController

@synthesize usernameCell, passwordCell, tweetText, sendButton, tableView, counterLabel;
@synthesize initialText, activityIndicator;

- (id)initWithText:(NSString *)text {
	if (self = [super initWithNibName:@"TFTweetController" bundle:nil]) {
		self.initialText = text;
	}
	return self;
}

- (TFTextEntryCell *)createCell {
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TFTextEntryCell" owner:nil options:nil];
	TFTextEntryCell *cell = [nib objectAtIndex:0];
	cell.delegate = self;
	cell.keyboardType = UIKeyboardTypeDefault;
	cell.autocorrectionType = UITextAutocorrectionTypeNo;
	cell.autocapitalizationType = UITextAutocapitalizationTypeNone;
	cell.enablesReturnKeyAutomatically = YES;
	cell.returnKeyType = UIReturnKeyNext;
	return cell;
}

- (void)checkText:(UITextView *)textView {
	NSInteger count = [textView.text length];
	self.sendButton.enabled = (count > 0 && count <= 140);
	
	if (count > 140) {
		self.counterLabel.textColor = [UIColor redColor];
	}
	else if (count > 120) {
		self.counterLabel.textColor = [UIColor orangeColor];
	}
	else {
		self.counterLabel.textColor = [UIColor darkTextColor];
	}
	
	self.counterLabel.text = [NSString stringWithFormat:@"%d", 140 - count];
}

- (void)viewDidLoad {
	self.usernameCell = [self createCell];
	self.usernameCell.label.text = @"Username";
	
	self.passwordCell = [self createCell];
	self.passwordCell.label.text = @"Password";
	self.passwordCell.secureTextEntry = YES;
	
	TFTextView *textView = [[TFTextView alloc] initWithFrame:CGRectMake(10, 10, 280, 120)];
	self.tweetText = textView;
	self.tweetText.delegate = self;
	self.tweetText.responderDelegate = self;
	self.tweetText.font = [UIFont systemFontOfSize:17.0];
	self.tweetText.text = self.initialText;
	[self checkText:self.tweetText];
	[textView release];
	
	self.activityIndicator = [TFActivityIndicator activityIndicator];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.usernameCell becomeFirstResponder];
}

- (void)viewDidUnload {
	self.usernameCell = nil;
	self.passwordCell = nil;
	self.tweetText = nil;
	self.sendButton = nil;
	self.tableView = nil;
	self.counterLabel = nil;
	self.activityIndicator = nil;
}

#pragma mark UIActions

- (IBAction)cancelTweet:(id)sender {
	[self.usernameCell resignFirstResponder];
	[self.passwordCell resignFirstResponder];
	[self.tweetText resignFirstResponder];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendTweet:(id)sender {
	[self.usernameCell resignFirstResponder];
	[self.passwordCell resignFirstResponder];
	[self.tweetText resignFirstResponder];
	
	[self.view addSubview:self.activityIndicator];
	self.activityIndicator.center = self.view.center;
	self.activityIndicator.transform = CGAffineTransformScale(self.activityIndicator.transform, 3, 3);
	self.activityIndicator.alpha = 0.0;
	
	[self.activityIndicator startAnimating];
	[UIView beginAnimations:@"ShowIndicator" context:nil];
	[UIView setAnimationDuration:0.5];
	self.activityIndicator.transform = CGAffineTransformIdentity;
	self.activityIndicator.alpha = 1.0;
	[UIView commitAnimations];
	
	[Limit postStatus:self.tweetText.text
				   withUsername:self.usernameCell.text
					   password:self.passwordCell.text
					   delegate:self];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	}
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Please enter your credentials:";
	}
	return @"What do you want to say?";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 44.0f;
	}
	return 150.0f;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			return self.usernameCell;
		}
		else {
			return self.passwordCell;
		}
	}
	else {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.contentView addSubview:tweetText];
		self.counterLabel.center = CGPointMake(260, 130);
		[cell.contentView addSubview:counterLabel];
		return cell;
	}
	
	return cell;
}

- (void)dealloc {
	[usernameCell release];
	[passwordCell release];
	[tweetText release];
	[sendButton release];
	[tableView release];
	[counterLabel release];
	[initialText release];
	[activityIndicator release];
	[super dealloc];
}

#pragma mark Text View Delegate methods

- (void)textViewDidChange:(UITextView *)textView {
	[self checkText:textView];
}

- (void)textViewDidBecomeFirstResponder:(TFTextView *)textView {
	if (self.tableView.frame.origin.y == kTableViewY) {
		[UIView beginAnimations:@"SlideUp" context:nil];
		CGPoint origCenter = self.tableView.center;
		self.tableView.center = CGPointMake(origCenter.x, origCenter.y - kSlideAmount);
		[UIView commitAnimations];
	}
}

- (void)textViewDidResignFirstResponder:(TFTextView *)textView {
	if (self.tableView.frame.origin.y < kTableViewY) {
		[UIView beginAnimations:@"SlideDown" context:nil];
		CGPoint center = self.tableView.center;
		self.tableView.center = CGPointMake(center.x, center.y + kSlideAmount);
		[UIView commitAnimations];
	}
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.usernameCell.textField) {
		[self.usernameCell resignFirstResponder];
		[self.passwordCell becomeFirstResponder];
	}
	else if (textField == self.passwordCell.textField) {
		[self.passwordCell resignFirstResponder];
		[self.tweetText becomeFirstResponder];
	}
	return YES;
}

#pragma mark TFTwitterStatus Delegate

- (void)statusUpdateComplete {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end