//
//  Collection.h
//  Small
//
//  Created by Artem Titoulenko on 5/30/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Collection : NSObject {
  NSString * collectionId;
  NSString * name;
  NSString * slug;
  NSString * creatorId;
  NSString * description;
  
  NSDictionary * posts;
  
  // Meta Data
  NSInteger postCount;
  NSInteger activeAt;
}

@property (nonatomic, retain) id collectionId;
@property (nonatomic, retain) id name;
@property (nonatomic, retain) id slug;
@property (nonatomic, retain) id creatorId;
@property (nonatomic, retain) id description;
@property (nonatomic, retain) id posts;

@property (nonatomic, assign) NSInteger postCount;
@property (nonatomic, assign) NSInteger activeAt;

@end
