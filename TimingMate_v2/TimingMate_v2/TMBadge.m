//
//  TMBadge.m
//  TimingMate_v2
//
//  Created by easonfafa on 7/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMBadge.h"

@implementation TMBadge
@synthesize numTasksFinishedWithinDeadline;
@synthesize numTasksFinishedExceedDeadline;
@synthesize isFirstTime;
@synthesize lastModifiedTask;

- (id)init
{
    self = [super init];
    if(self){
        numTasksFinishedWithinDeadline = 0;
        numTasksFinishedExceedDeadline = 0;
        isFirstTime = true;
        lastModifiedTask = nil;
    }
    return self;
}
#pragma helper
-(void)increaseWithin{
    numTasksFinishedWithinDeadline += 1;
}
-(void)increaseExceed{
    numTasksFinishedExceedDeadline += 1;
}
-(void)decreaseWithin{
    numTasksFinishedWithinDeadline -= 1;
}
-(void)decreaseExceed{
    numTasksFinishedExceedDeadline -= 1;
}
-(void)setIsFirstTime{
    isFirstTime = false;
}
-(void)setLastModifiedTask:(TMTask *)task{
    lastModifiedTask = task;
}
#pragma archiving NSCode functions
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:numTasksFinishedWithinDeadline forKey:@"numTasksFinishedWithinDeadline"];
    [aCoder encodeInteger:numTasksFinishedExceedDeadline forKey:@"numTasksFinishedExceedDeadlin"];
    [aCoder encodeBool:isFirstTime forKey:@"isFirstTime"];
    [aCoder encodeObject:lastModifiedTask forKey:@"lastModifiedTask"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        [self setNumTasksFinishedWithinDeadline:[aDecoder decodeIntegerForKey:@"numTasksFinishedWithinDeadline"]];
        [self setNumTasksFinishedExceedDeadline:[aDecoder decodeIntegerForKey:@"numTasksFinishedExceedDeadline"]];
        [self setIsFirstTime:[aDecoder decodeBoolForKey:@"isFirstTime"]];
        [self setLastModifiedTask:[aDecoder decodeObjectForKey:@"lastModifiedTask"]];
    }
    return self;
}
@end
