//
//  TMBadgeStore.m
//  TimingMate_v2
//
//  Created by easonfafa on 7/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMBadgeStore.h"
#import "TMBadge.h"
@implementation TMBadgeStore

- (id)init
{
    self = [super init];
    if (self){
        NSString *path = [self badgeArchivePath];
        badge = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(!badge)
        {
            badge = [[TMBadge alloc] init];
        }
    }
    return self;
}
#pragma Helper
- (void)increaseNumTasksWithinDeadline
{
    [badge increaseWithin];
    [self saveChanges];
}

- (void)increaseNumTasksExceedDeadline
{
    [badge increaseExceed];
    [self saveChanges];
}
- (TMBadge *)returnBadge{
    return badge;
}
-(void)setIsFirstTime{
    [badge setIsFirstTime];
    [self saveChanges];
}
-(void)setLastModifiedTask:(TMTask *)task{
    [badge setLastModifiedTask:task];
    [self saveChanges];
}
#pragma Archiving Functions
- (NSString *)badgeArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"badge.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self badgeArchivePath];
    return [NSKeyedArchiver archiveRootObject:badge toFile:path];
}
#pragma static functions
+ (TMBadgeStore *)sharedStore{
    static TMBadgeStore *sharedStore = nil;
    if (!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

@end
