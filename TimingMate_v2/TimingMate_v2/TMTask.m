//
//  TMTask.m
//  TimingMate_v2
//
//  Created by easonfafa on 6/28/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMTask.h"
#import "TMListItem.h"

@implementation TMTask
@synthesize title;
@synthesize list;
@synthesize allowedCompletionTime;
@synthesize totalUsedTime;
@synthesize creationTime;
@synthesize isFinished;

- (id)initWithTitle:(NSString *)taskTitle list:(TMListItem *)list allowedTime:(double)allowedTime
{
    self = [super init];
    if (self){
        self.title = taskTitle;
        self.list = list;
        self.allowedCompletionTime =allowedTime;
        self.totalUsedTime = 0.0;
        self.isFinished = false;
        self.creationTime = [NSDate date];
    }
    NSLog(@"New Task Created, Task name: %@ list Name: %@",taskTitle,list.title);
    return self;
}
#pragma archiving NSCode functions
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:list forKey:@"list"];
    [aCoder encodeDouble:allowedCompletionTime forKey:@"allowedCompletionTime"];
    [aCoder encodeDouble:totalUsedTime forKey:@"totalUsedTime"];
    [aCoder encodeObject:creationTime forKey:@"creattionTime"];
    [aCoder encodeBool:isFinished forKey:@"isFinished"];
    NSLog(@"aCoder encoded title: %@ list: %@",title,list.title);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setList:[aDecoder decodeObjectForKey:@"list"]];
        [self setAllowedCompletionTime:[aDecoder decodeDoubleForKey:@"allowedCompletionTime"]];
        [self setTotalUsedTime:[aDecoder decodeDoubleForKey:@"totalUsedTime"]];
        [self setCreationTime:[aDecoder decodeObjectForKey:@"creationTime"]];
        [self setIsFinished:[aDecoder decodeBoolForKey:@"isFinished"]];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[TMTask class]]){
        TMTask *other = object;
        if ([self.title isEqual:other.title] && [self.list.title isEqual:other.list.title] && self.allowedCompletionTime == other.allowedCompletionTime){
             return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
@end
