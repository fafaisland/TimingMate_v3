//
//  TMBadge.h
//  TimingMate_v2
//
//  Created by easonfafa on 7/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TMTask;

@interface TMBadge : NSObject <NSCoding>

@property (nonatomic) NSInteger numTasksFinishedWithinDeadline;
@property (nonatomic) NSInteger numTasksFinishedExceedDeadline;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic, retain) TMTask *lastModifiedTask;

-(void)increaseWithin;
-(void)decreaseWithin;
-(void)increaseExceed;
-(void)decreaseExceed;
-(void)setIsFirstTime;
-(void)setLastModifiedTask:(TMTask *)task;
@end
