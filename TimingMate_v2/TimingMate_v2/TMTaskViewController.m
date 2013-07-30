//
//  TMTaskViewController.m
//  TimingMate_v2
//
//  Created by easonfafa on 6/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMTaskViewController.h"
#import "TMEditTaskViewController.h"
#import "TMViewControllerStore.h"
#import "DDMenuController.h"
#import "TMtask.h"
#import "TMListItem.h"
#import "TMViewControllerStore.h"
#import "TMGlobal.h"
#import "TMTimer.h"
#import "TMListStore.h"
#import "TMTaskStore.h"
#import "TMListViewController.h"
#import "TMBadge.h"
#import "TMBadgeStore.h"
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@implementation TMTaskViewController
@synthesize task;

- (id)initWithIntro{
    self = [super init];
    if (self){
        [self.view addSubview:introAppView];
        hasIntroView = true;
        task = nil;
    }
    return self;
}

- (id)initWithNoTaskChosen{
    self = [super init];
    if (self){
        [self.view addSubview:noTaskChosenView];
        hasNoTaskChosenView = true;
        task = nil;
    }
    return self;
}
- (id)initWithTask:(TMTask *)aTask{
    self = [super init];
    if (self){
        moreOptions = false;
        timeDetail = false;
        [self setupTimer];
        task = aTask;
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (task != nil){
        [super viewWillAppear:animated];
        listNameLabel.text = task.list.title;
        taskNameLabel.text = task.title;
        
        totalSpentTime.text = TMTimerStringFromSecondsShowHourMinSec(task.totalUsedTime);
        allowedTime.text = TMTimerStringFromSecondsShowHourAndMin(task.allowedCompletionTime);
        
        if (task.isFinished == true){
            if(task.totalUsedTime <= task.allowedCompletionTime){
                [self appearBadgeWithName:@"withinBadge"];
            }else{
                [self appearBadgeWithName:@"exceedBadge"];
            }
            
        }else{
            [badgeButton removeFromSuperview];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[TMTaskStore sharedStore] updateTask:task withTotalTimeSpent:task.totalUsedTime];
    [timer invalidate];
    
}
#pragma mark - helper
- (void)updateWithNoTaskChosen{
    if (hasIntroView == true){
        [introAppView removeFromSuperview];
        hasIntroView = false;
    }
    
    [self.view addSubview:noTaskChosenView];
    hasNoTaskChosenView = true;
}

- (void)updateWithTask:(TMTask *)aTask
{
    if (hasIntroView == true){
        [introAppView removeFromSuperview];
        hasIntroView = false;
    }
    if (hasNoTaskChosenView == true){
        [noTaskChosenView removeFromSuperview];
        hasNoTaskChosenView = false;
    }
    
    [[TMBadgeStore sharedStore] setLastModifiedTask:aTask];
    
    moreOptions = false;
    timeDetail = false;
    
    [self resetTimer];
    task = aTask;
    listNameLabel.text = task.list.title;
    taskNameLabel.text = task.title;
    
    if (task.isFinished == true){
        if(task.totalUsedTime <= task.allowedCompletionTime){
            [self appearBadgeWithName:@"withinBadge"];
        }else{
            [self appearBadgeWithName:@"exceedBadge"];
        }
        
    }else{
        [badgeButton removeFromSuperview];
    }

    totalSpentTime.text = TMTimerStringFromSecondsShowHourMinSec(task.totalUsedTime);
    allowedTime.text = TMTimerStringFromSecondsShowHourAndMin(task.allowedCompletionTime);
    
    //badgeButton = [[UIButton alloc] init];
    //[badgeButton addTarget:self action:@selector(badgeButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    
}

- (void)startTimer{
    //timerSubview.frame = CGRectMake(0,300,320,100);
    //[self.view addSubview:timerSubview];
    //totalTimeTimerLabel.text = [NSString stringWithFormat:@"%@ Hour %@ Min",setHourTextField.text,setMinTextField.text];
    currentTimeLeft.frame = CGRectMake(142,280,50,40);
    
    [self.view addSubview:currentTimeLeft];
    [self createTimer];
    
    //pauseButton.frame = startButton.frame;
    //[startButton setHidden:YES];
    //[self.view addSubview:pauseButton];
}

- (void)removeGreyBackground{
    [greyBackground removeFromSuperview];
}

- (void)appearBadgeWithName:(NSString *)badgeName{
    NSString *badgePic;
    if ([badgeName isEqual: @"withinBadge"]){
        badgePic = @"withinBadge.png";
    }else{
        badgePic = @"exceedBadge.png";
    }
    badgeButton = [[UIButton alloc] init];
    [badgeButton addTarget:self action:@selector(badgeButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [badgeButton setBackgroundImage:[UIImage imageNamed:badgePic] forState: UIControlStateNormal];
    badgeButton.frame = CGRectMake(68,158,186,186);
    [self.view addSubview:badgeButton];
}
#pragma mark - Event Handler
- (IBAction)toggleTimer:(id)sender
{
    if (isTiming == false){
        [timerButton setBackgroundImage:[UIImage imageNamed:@"timer-start.png"] forState:UIControlStateNormal];
        [self startTimer];
        isTiming = true;
    }else{
        if (isiPhone5){
            greyBackground.frame = CGRectMake(0,0,320,548);

        }else{
            greyBackground.frame = CGRectMake(0,0,320,460);
        }
        [self.view addSubview:greyBackground];
    }
}
- (IBAction)changeToListView:(id)sender
{
    [[[TMViewControllerStore sharedStore] returnMenuController] showLeftController:YES];
}
- (IBAction)resetTimer:(id)sender{
    [self resetTimer];
}

- (IBAction)continueTimer:(id)sender
{
    [self removeGreyBackground];
    if (isPaused == true){
        [self createTimer];
        isPaused = false;
    }
}

- (IBAction)stopTimer
{
    [timer invalidate];
    //timer = nil;
    isPaused = true;
    [self removeGreyBackground];
}

- (IBAction)createTask:(id)sender{
    TMEditTaskViewController *createTaskViewController = [[TMEditTaskViewController alloc] init];
    [self presentViewController:createTaskViewController animated:YES completion:NULL];
}
- (IBAction)editTask:(id)sender{
    TMEditTaskViewController *createTaskViewController = [[TMEditTaskViewController alloc] initWithTask:task];
    [self presentViewController:createTaskViewController animated:YES completion:NULL];
}
- (IBAction)changeToTaskStatusView:(id)sender
{
    //TMTaskStatusViewController *tmtsvc = [[TMViewControllerStore sharedStore] returnTaskStatusController];
    
    if (!moreOptions){
        //tmtsvc.view.frame = CGRectMake(150, 64, 164, 30);
        //taskStatus.frame = CGRectMake(130,42,168,30);
        //[self addChildViewController:tmtsvc];
        //[self.view addSubview:tmtsvc.view];
        [self.view addSubview:taskStatus];
        moreOptions = true;
    }else{
        //[tmtsvc willMoveToParentViewController:nil];
        //[tmtsvc.view removeFromSuperview];
        //[tmtsvc removeFromParentViewController];
        [taskStatus removeFromSuperview];
        moreOptions = false;
    }
}

- (IBAction)removeTaskStatusView:(id)sender
{
    [taskStatus removeFromSuperview];
}

- (IBAction)changeToTimeDetailView:(id)sender
{
    if (!timeDetail){
        if (isiPhone5){
            taskDetailView.frame = CGRectMake(0,444, 320, 86);
        }else{
            taskDetailView.frame = CGRectMake(0,358, 320, 86);
        }
        [self.view addSubview:taskDetailView];
        timeDetail = true;
    }else{
        [taskDetailView removeFromSuperview];
        timeDetail = false;
    }
}

- (IBAction)deleteTask:(id)sender
{
    TMListStore *ls = [TMListStore sharedStore];
    TMListItem *l = task.list;
    TMTaskStore *ts = [TMTaskStore sharedStore];
    [ls removeTask:task FromList:l.title];
    [ts removeTask:task];
    
    [[[TMViewControllerStore sharedStore] returnTMtvc] updateWithNoTaskChosen];
    [[[[TMViewControllerStore sharedStore] returnTMlvc] returnListTableView] reloadData];
    [[[TMViewControllerStore sharedStore] returnMenuController] showLeftController:YES];
    
}

- (void)badgeButtonTouchDown
{
    [self.view addSubview:unfinishView];
}

- (IBAction)finishTask:(id)sender
{
    //[self fallOneFlower:victoryImage1 WithVelocity:4.0 FromX:10 FromY:0 ToX:10];
    //[self fallOneFlower:victoryImage2 WithVelocity:3.0 FromX:30 FromY:0 ToX:30];
    //[self fallOneFlower:victoryImage3 WithVelocity:3.5 FromX:100 FromY:0 ToX:100];
    
    [taskStatus removeFromSuperview];
    if (task.isFinished == false){
        [self resetTimer];
        
        [[TMTaskStore sharedStore] updateTaskToggleFinished:task];
        task.isFinished = true;
        TMBadgeStore *bs = [TMBadgeStore sharedStore];
        if (task.totalUsedTime <= task.allowedCompletionTime){
            [self appearBadgeWithName:@"withinBadge"];
            //[self.view addSubview:badgeButton];
            [bs increaseNumTasksWithinDeadline];
        }else{
            [self appearBadgeWithName:@"exceedBadge"];
            //[self.view addSubview:badgeButton];
            [bs increaseNumTasksExceedDeadline];
        }
        [[[TMViewControllerStore sharedStore] returnTMlvc] updateBadges];
    }else{
        [self unfinishTask];
    }
    //[self fallOneFlower:smileFaceImage WithVelocity:4.0 FromX:10 FromY:0 ToX:0];
}

- (IBAction)cancelUnfinish:(id)sender
{
    [unfinishView removeFromSuperview];
}

- (IBAction)unfinishTask:(id)sender{
    [self unfinishTask];
}

- (void)unfinishTask{
    [badgeButton removeFromSuperview];
    [unfinishView removeFromSuperview];
    
    [[TMTaskStore sharedStore] updateTaskToggleFinished:task];
    task.isFinished = false;
    TMBadgeStore *bs = [TMBadgeStore sharedStore];
    if (task.totalUsedTime <= task.allowedCompletionTime){
        [bs decreaseNumTasksWithinDeadline];
    }else{
        [bs decreaseNumTasksExceedDeadline];
    }
    [[[TMViewControllerStore sharedStore] returnTMlvc] updateBadges];

}

#pragma mark - Timer Methods
- (void)setupTimer
{
    timerCount = 0;
    timerTime = 1800;
    timer = [[NSTimer alloc] init];
    isTiming = false;
    isPaused = false;
    currentTimeLeft = [[UILabel alloc] init];
    currentTimeLeft.text = @"30:00";
}
- (void)resetTimer{
    [timerButton setBackgroundImage:[UIImage imageNamed:@"timer-restart.png"] forState:UIControlStateNormal];
    [self removeGreyBackground];
    [timer invalidate];
    [currentTimeLeft removeFromSuperview];
    /*
     timerCount = 0;
     currentTimeLeft.text = @"30:00";
     isTiming = false;
     isPaused = false;*/
    [self setupTimer];

}
- (void)createTimer
{
    //if (timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
    //}

}
- (void)increaseTimerCount
{
    if(timerCount < timerTime){
        timerCount += 1;
        [self setLabelFromLeftTime];
        task.totalUsedTime += 1;
        [totalSpentTime setText:TMTimerStringFromSecondsShowHourMinSec(task.totalUsedTime)];
    }
    else{
        [self resetTimer];
    }
}

- (void)setLabelFromLeftTime
{
    [currentTimeLeft setText:TMTimerStringFromSecondsShowMin(timerTime-timerCount)];
    
}

#pragma mark - falling flowers
- (void)fallOneFlower:(UIImageView *)vi WithVelocity:(NSTimeInterval)v FromX:(CGFloat)fx FromY:(CGFloat)fy ToX:(CGFloat)tx
{
    vi.frame = CGRectMake(fx, fy, 300, 122);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:v];
    [self.view addSubview:vi];
    [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromTop forView:vi cache:YES];
    vi.frame = CGRectMake(tx, 460, 300, 122);
    [UIView commitAnimations];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //if [[TMTaskStore sharedStore] tasksByListTitle:addField.text] != nil]]
    //[self showIdenticalTitleWarning];
    //return NO;
    /*if (textField == taskNameTextField){
        [textField resignFirstResponder];
        return YES;
    }
    return NO;*/
    [textField resignFirstResponder];
    return YES;
}

@end
