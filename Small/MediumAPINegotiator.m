//
//  MediumAPINegotiator.m
//  Small
//
//  Created by Artem Titoulenko on 5/30/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import "MediumAPINegotiator.h"

@implementation NSDictionary(Utilities)
-(id)objectForPath:(NSString *)path {
  NSMutableArray * keys = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"."]];
  
  id parent;
  while ([keys count] > 1) {
    parent = [parent objectForKey:[keys objectAtIndex:0]];
    [keys removeObjectAtIndex:0];
  }
  
  return [parent objectForKey:[keys objectAtIndex:0]];
}
@end

@interface MediumAPINegotiator () {
  id connection;
  id connectionData;
}
@end

@implementation MediumAPINegotiator

@synthesize delegate;

-(id)init {
  apiEndpoints = [NSDictionary dictionaryWithObjectsAndKeys:@"collections", @"http://medium.com/collections", nil];
  return self;
}

-(NSDictionary *)collections {
  NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://medium.com/collections?apiv=1"]
                                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval: 60.0];
  
  connectionData = [[NSMutableData alloc] init];
  connection = [NSURLConnection connectionWithRequest:request delegate:self];
  
  if (!connection) {
    NSLog(@"Could not create the connection. Check your network settings");
  }
}

#pragma mark - Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  connectionData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [connectionData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

#pragma mark - Connection Finished Loading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSString * result = [[NSString alloc] initWithData:connectionData encoding:NSASCIIStringEncoding];
  result = [result substringFromIndex:16];
  NSData * correctData = [result dataUsingEncoding:NSUTF8StringEncoding];
  
  NSError * error = nil;
  NSDictionary * json = [NSJSONSerialization JSONObjectWithData:correctData options:NSJSONReadingMutableLeaves error:&error];
    
  NSMutableArray * collections = [json objectForPath:@"payload.value"];
  for (int i = 0; i < [collections count]; i++) {
    // fill it up
  }
  
  if ([delegate respondsToSelector:@selector(receivedCollections:)]) {
    [delegate receivedCollections:collections];
  }
}


@end
