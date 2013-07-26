//
//  TMViewControllerStore.m
//  TimingMate_v2
//
//  Created by easonfafa on 6/29/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMViewControllerStore.h"
#import "TMTaskViewController.h"
#import "TMListViewController.h"
#import "DDMenuController.h"
#import "TMTaskStore.h"

@implementation TMViewControllerStore
- (id)init
{
    self = [super init];
    if (self){
        if (!tmtvc){
            int taskCount = [[TMTaskStore sharedStore] returnAllTasks].count;
            if (taskCount > 0){
                tmtvc = [[TMTaskViewController alloc] init];
            }else{
                tmtvc = [[TMTaskViewController alloc] initWithIntro];
            }
        }
        if (!menuController){
            menuController = [[DDMenuController alloc] initWithRootViewController:tmtvc];
        }
        if (!tmlvc){
            tmlvc = [[TMListViewController alloc] init];
        }
        menuController.leftViewController = tmlvc;
    }
    return self;
}
- (TMTaskViewController *)returnTMtvc
{
    return tmtvc;
}
- (TMListViewController *)returnTMlvc
{
    return tmlvc;
}
- (DDMenuController *)returnMenuController
{
    return menuController;
}
- (TMTaskStatusViewController *)returnTaskStatusController
{
    return tmtsvc;
}
- (TMTimeDetailViewController *)returnTimeDetailController
{
    return tmtdvc;
}
#pragma mark - static functions
+ (TMViewControllerStore *)sharedStore{
    static TMViewControllerStore *sharedStore = nil;
    if (nil == sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
@end
