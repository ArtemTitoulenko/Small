//
//  Post.h
//  Small
//
//  Created by Artem Titoulenko on 5/30/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject {
  NSString * postId;
  NSString * creatorId;
  NSString * homeCollectionId;
  
  NSString * title;
  NSString * snippet;  
  
  // Meta Data
  NSInteger updatedAt;
}

@property (nonatomic, retain) id collectionId;
@property (nonatomic, retain) id homeCollectionId;
@property (nonatomic, retain) id title;
@property (nonatomic, retain) id creatorId;
@property (nonatomic, retain) id snippet;

@property (nonatomic, assign) NSInteger updatedAt;


@end
