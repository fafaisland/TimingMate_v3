//
//  TMEditTaskViewController.m
//  TimingMate_v2
//
//  Created by easonfafa on 6/27/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMEditTaskViewController.h"
#import "TMViewControllerStore.h"
#import "TMTaskViewController.h"
#import "TMListViewController.h"
#import "TMListStore.h"
#import "TMListItem.h"
#import "TMTaskStore.h"
#import "TMTask.h"
#import "TMGlobal.h"

NSString * const TMListUncategorized = @"Uncategorized";
enum{
    TMHourComponent = 0,
    TMMinuteComponent = 1
};

@implementation TMEditTaskViewController

@synthesize task;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isEditing = false;
    }
    return self;
}
/*
- (id)init
{
    self = [super init];
    if (self){
        isEditing = false;
    }
}
*/
- (id)initWithTask:(TMTask *)t{
    self = [super init];
    if(self){
        task = t;
        isEditing = true;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    if(isEditing == false){
        [self initializeListPickerWithString:TMListUncategorized];
        selectedHourRow = 10;
        selectedMinuteRow = 30;
        [self initializeTimePicker];
    }else{
        taskNameTextField.text = task.title;
        listTitleLabel.text = task.list.title;
        allowedTimeLabel.text = TMTimerStringFromSecondsShowHourAndMin(task.allowedCompletionTime);
        [self initializeListPickerWithString:task.list.title];
        
        selectedHourRow = TMTimerHourFromSeconds(task.allowedCompletionTime);
        selectedMinuteRow = TMTimerMinFromSeconds(task.allowedCompletionTime);
        [self initializeTimePicker];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [taskNameTextField becomeFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handler
- (IBAction)cancelTask:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)doneTask:(id)sender{
    if ([taskNameTextField.text isEqualToString:@""]) {
        taskNameTextField.placeholder = @"Please enter a task name";
        return;
    }
    NSString *taskTitle = taskNameTextField.text;
    TMListItem *list = [[[TMListStore sharedStore] returnAllLists] objectAtIndex:selectedList];
    double allowedTime = [self getSecondsFromTimePicker];
    TMTask *newTask =[[TMTaskStore sharedStore] createTaskWithTitle:taskTitle list:list allowedTime:allowedTime];
    [[TMListStore sharedStore] addTask:newTask toList:list.title];
    [[[[TMViewControllerStore sharedStore] returnTMlvc] returnListTableView] reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
    /*TMTaskViewController *tmtvc = [[TMTaskViewController alloc] init];
    [self presentViewController:tmtvc animated:NO completion:NULL];*/
}

- (IBAction)showListPicker:(id)sender
{
    [self showPicker:listPickerView];
}

- (IBAction)showTimePicker:(id)sender
{
    [self showPicker:timePickerView];
}

#pragma mark - Helper Functions
- (NSString *)makeTimeStringFromHours:(int)hours Minutes:(int) minutes
{
    NSMutableString *timeStr = [NSMutableString string];
    if (hours != 0)
        [timeStr appendString:[NSString stringWithFormat:@"%d hr ", hours]];
    
    [timeStr appendString:[NSString stringWithFormat:@"%d min ", minutes]];
    
    return timeStr;
}
- (double)getSecondsFromTimePicker
{
    return selectedHourRow*3600.0 + selectedMinuteRow*60.0;
}

#pragma mark - Picker Functions
- (void)showPicker:(UIPickerView *)picker
{
    if (!actionSheet)
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [actionSheet addSubview:picker];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:doneButton];
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (void)dismissActionSheet:(id)sender
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == listPickerView)
        return 1;
    else // pickerView == timePickerView
        return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == listPickerView)
        return pickerArray.count;
    else { // pickerView == timePickerView
        if (component == TMHourComponent)
            return 100;
        else // component == TMMinuteComponent
            return 60;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == listPickerView){
        selectedList = row;
        [listTitleLabel setText:[pickerArray objectAtIndex:selectedList]];
    }
    else { // pickerView == timePickerView
        if (component == TMHourComponent)
            selectedHourRow = row;
        else // component == TMMinuteComponent
            selectedMinuteRow = row;
        [allowedTimeLabel setText:[self makeTimeStringFromHours:selectedHourRow Minutes:selectedMinuteRow]];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == listPickerView)
        return [pickerArray objectAtIndex:row];
    else // pickerView == timePickerView
        return [self timePickerStringFromRow:row forComoonent:component];
}

- (NSString *)timePickerStringFromRow:(NSInteger)row forComoonent:(NSInteger)component
{
    if (component == TMHourComponent)
        return [NSString stringWithFormat:@"%d hr", row];
    else // component == TMMinuteComponent
        return [NSString stringWithFormat:@"%d min", row];
}

- (void)initializeListPickerWithString:(NSString *)s
{
    if (!listPickerView) {
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        listPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        
        pickerArray = [NSMutableArray array];
        //[pickerArray addObject:TMListUncategorized];
        
        NSArray *allLists = [[TMListStore sharedStore] returnAllLists];
        for (TMListItem *list in allLists) {
            [pickerArray addObject:list.title];
        }
        
        listPickerView.showsSelectionIndicator = YES;
        listPickerView.dataSource = self;
        listPickerView.delegate = self;
    }
    
    if (s == TMListUncategorized) {
        selectedList = 0;
    }
    else {
        selectedList = [[TMListStore sharedStore] indexOfListByTitle:s];
    }
    
    [listPickerView selectRow:selectedList inComponent:0 animated:NO];
}

- (void)initializeTimePicker
{
    if (!timePickerView) {
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        timePickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        
        timePickerView.showsSelectionIndicator = YES;
        timePickerView.dataSource = self;
        timePickerView.delegate = self;
    }
    
    //selectedMinuteRow = task.expectedTimeMinutes;
    //selectedHourRow = task.expectedTimeHours;
    [timePickerView selectRow:selectedMinuteRow inComponent:TMMinuteComponent animated:NO];
    [timePickerView selectRow:selectedHourRow inComponent:TMHourComponent animated:NO];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //if [[TMTaskStore sharedStore] tasksByListTitle:addField.text] != nil]]
    //[self showIdenticalTitleWarning];
    //return NO;
    if (textField == taskNameTextField){
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

/*
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self addLists:addField.text];
        [listTableView reloadData];
    } //else if (textField == editField) {
    //if (self.isEditing)
    //  [self endCellEdit];
    //}
}
*/
@end
