//
//  Limit.m
//  LocateMe
//
//  Created by BRETT WEIK-ULRICH on 9/18/10.
//  Copyright 2010 Uninteractive. All rights reserved.
//

#import "Limit.h"
#import "TFAppHelpers.h"


@implementation Limit

+ (void)initialize {
	NSDictionary *headers = [NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" 
														forKey:@"Content-Type"];
	[self setHeaders:headers];
	[self setBaseURL:[NSURL URLWithString:@"http://looce.com:3000"]];
	//[self setBaseURL:[NSURL URLWithString:@"http://twitter.com"]];
	[self setDelegate:self];
}

+ (void)postStatus:(NSString *)status 
      withUsername:(NSString *)username
          password:(NSString *)password
          delegate:(id)aDelegate {
	
	[self setBasicAuthWithUsername:username password:password];
	NSDictionary *body = [NSDictionary dictionaryWithObject:status forKey:@"status"];
	NSDictionary *opts = [NSDictionary dictionaryWithObject:body forKey:@"body"];
	[self postPath:@"/statuses/update.json" withOptions:opts object:aDelegate];
}

#pragma mark HRRequestOperation delegate methods

+ (void)restConnection:(NSURLConnection *)connection 
      didFailWithError:(NSError *)error 
                object:(id)object {
	// Handle connection errors.  Failures to connect to the server, etc.
	TFAlertWithErrorAndDelegate(error, nil);
}

+ (void)restConnection:(NSURLConnection *)connection 
       didReceiveError:(NSError *)error 
              response:(NSHTTPURLResponse *)response object:(id)object {
	// Handle invalid responses, 404, 500, etc.
	TFAlertWithErrorAndDelegate(error, nil);
}

+ (void)restConnection:(NSURLConnection *)connection 
  didReceiveParseError:(NSError *)error 
          responseBody:(NSString *)string {
	// Request was successful, but couldn't parse the data returned by the server. 
	TFAlertWithErrorAndDelegate(error, nil);
}

// Fires off method in delegate: receivedNewsItems:
+ (void)restConnection:(NSURLConnection *)connection 
     didReturnResource:(id)resource 
                object:(id)anObject {
	if ([anObject respondsToSelector:@selector(statusUpdateComplete)]) {
		[anObject statusUpdateComplete];
	}
}

@end
