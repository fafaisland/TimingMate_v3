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

@implementation TMTaskViewController
@synthesize task;

- (id)initWithIntro{
    self = [super init];
    if (self){
        [self.view addSubview:introAppView];
        hasIntroView = true;
    }
    return self;
}

- (id)initWithNoTaskChosen{
    self = [super init];
    if (self){
        [self.view addSubview:noTaskChosenView];
        hasNoTaskChosenView = true;
    }
    return self;
}
- (id)initWithTask:(TMTask *)aTask{
    self = [super init];
    if (self){
        if (hasIntroView == true){
            [introAppView removeFromSuperview];
            hasIntroView = false;
        }
        if (hasNoTaskChosenView == true){
            [noTaskChosenView removeFromSuperview];
            hasNoTaskChosenView = false;
        }
        moreOptions = false;
        timeDetail = false;
        timerCount = 0;
        timer = [[NSTimer alloc] init];
        isTiming = false;
        isPaused = false;
        currentTimeLeft = [[UILabel alloc] init];
        currentTimeLeft.text = @"30:00";
        timerTime = 1800;
        
        task = aTask;
        listNameLabel.text = task.list.title;
        taskNameLabel.text = task.title;
        
        totalSpentTime.text = TMTimerStringFromSecondsShowHourAndMin(task.totalUsedTime);
        allowedTime.text = TMTimerStringFromSecondsShowHourAndMin(task.allowedCompletionTime);
        
        badgeButton = [[UIButton alloc] init];
        [badgeButton addTarget:self action:@selector(badgeButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    setMinTextField.delegate = self;
    setMinTextField.delegate = self;
    
}
#pragma mark - helper
- (void)updateWithTask:(TMTask *)aTask
{
    task = aTask;
    listNameLabel.text = task.list.title;
    taskNameLabel.text = task.title;
    //totalSpentTime.text = TMTimerStringFromSecondsShowHourAndMin(task.totalUsedTime);
    allowedTime.text = TMTimerStringFromSecondsShowHourAndMin(task.allowedCompletionTime);
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
        greyBackground.frame = CGRectMake(0,0,320,480);
        [self.view addSubview:greyBackground];
    }
}
- (IBAction)changeToListView:(id)sender
{
    [[[TMViewControllerStore sharedStore] returnMenuController] showLeftController:YES];
}
- (IBAction)resetTimer:(id)sender{
    [timerButton setBackgroundImage:[UIImage imageNamed:@"timer-restart.png"] forState:UIControlStateNormal];
    [self removeGreyBackground];
    [timer invalidate];
    [currentTimeLeft removeFromSuperview];
    timerCount = 0;
    currentTimeLeft.text = @"30:00";
    isTiming = false;
    isPaused = false;
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
        taskStatus.frame = CGRectMake(130,42,168,30);
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

- (IBAction)changeToTimeDetailView:(id)sender
{
    if (!timeDetail){
        taskDetailView.frame = CGRectMake(0,358, 320, 86);
        [self.view addSubview:taskDetailView];
        timeDetail = true;
    }else{
        [taskDetailView removeFromSuperview];
        timeDetail = false;
    }
}

- (IBAction)finishTask:(id)sender
{
    //[self fallOneFlower:victoryImage1 WithVelocity:4.0 FromX:10 FromY:0 ToX:10];
    //[self fallOneFlower:victoryImage2 WithVelocity:3.0 FromX:30 FromY:0 ToX:30];
    //[self fallOneFlower:victoryImage3 WithVelocity:3.5 FromX:100 FromY:0 ToX:100];
    
    [taskStatus removeFromSuperview];
    [self appearBadgeWithName:@"withinBadge"];
    //[self fallOneFlower:smileFaceImage WithVelocity:4.0 FromX:10 FromY:0 ToX:0];
}

- (IBAction)deleteTask:(id)sender
{
    TMListStore *ls = [TMListStore sharedStore];
    TMListItem *l = task.list;
    TMTaskStore *ts = [TMTaskStore sharedStore];
    [ls removeTask:task FromList:l.title];
    [ts removeTask:task];
    
    [[[[TMViewControllerStore sharedStore] returnTMlvc] returnListTableView] reloadData];
    [[[TMViewControllerStore sharedStore] returnMenuController] showLeftController:YES];
    
}
- (void)badgeButtonTouchDown
{
    [self.view addSubview:unfinishView];
}
- (IBAction)cancelUnfinish:(id)sender
{
    [unfinishView removeFromSuperview];
}
- (IBAction)unfinishTask:(id)sender{
    [badgeButton removeFromSuperview];
    [unfinishView removeFromSuperview];
}
#pragma mark - Timer Methods
- (void)createTimer
{
    //if (timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
    //}

}
- (void)increaseTimerCount
{
    timerCount += 1;
    [self setLabelFromLeftTime];
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
