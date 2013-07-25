//
//  TMBadge.h
//  TimingMate_v2
//
//  Created by easonfafa on 7/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBadge : NSObject <NSCoding>

@property (nonatomic) NSInteger numTasksFinishedWithinDeadline;
@property (nonatomic) NSInteger numTasksFinishedExceedDeadline;
-(void)increaseWithin;
-(void)increaseExceed;
@end
