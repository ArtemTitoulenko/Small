//
//  MediumAPINegotiator.h
//  Small
//
//  Created by Artem Titoulenko on 5/30/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MediumAPIConsumer <NSObject>
-(void)receivedCollections:(NSDictionary *)collections;
@end

@interface MediumAPINegotiator : NSObject  {
  NSDictionary * apiEndpoints;
}

@property id <MediumAPIConsumer> delegate;

-(NSDictionary *)collections;
@end
