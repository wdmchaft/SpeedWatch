//
//  Limit.h
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <HTTPRiot/HTTPRiot.h>


@protocol LimitDelegate
@optional
- (void)statusUpdateComplete;
@end

@interface Limit : HRRestModel {
	
}

+ (void)postStatus:(NSString *)status 
      withUsername:(NSString *)username
          password:(NSString *)password
          delegate:(id)aDelegate;

@end