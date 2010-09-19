//
//  TFAppHelpers.h
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

void TFAlertWithMessageAndDelegate(NSString *message, id theDelegate);
void TFAlertWithErrorAndDelegate(NSError *error, id theDelegate);

void TFLogRect(NSString *message, CGRect rect);
void TFLogSize(NSString *message, CGSize size);
