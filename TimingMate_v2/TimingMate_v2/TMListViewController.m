//
//  TMListViewController.m
//  TimingMate_v2
//
//  Created by easonfafa on 6/25/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMListViewController.h"
#import "TMListsViewEditableCell.h"
#import "TMListItem.h"
#import "TMListStore.h"
#import "TMTaskStore.h"
#import "TMTask.h"
#import "TMViewControllerStore.h"
#import "TMTaskViewController.h"
#import "DDMenuController.h"
#import "TMBadge.h"
#import "TMBadgeStore.h"
@implementation TMListViewController
@synthesize selectedIndexPath;

- (id)init{
    self = [super init];
    [listTableView setSeparatorColor:[UIColor orangeColor]];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(self){}
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"TMListsViewEditableCell" bundle:nil];
    [listTableView registerNib:nib
         forCellReuseIdentifier:TMListsViewEditableCellIdentifier];
    [self registerForKeyboardNotifications];
    if(!expandedSections){
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    listTableView.allowsSelectionDuringEditing = YES;
    TMBadge *badge = [[TMBadgeStore sharedStore] returnBadge];
    numTasksWithin.text = [NSString stringWithFormat:@"%d", badge.numTasksFinishedWithinDeadline];
    numTasksExceed.text = [NSString stringWithFormat:@"%d", badge.numTasksFinishedExceedDeadline];
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.editing = NO;
    [addField setText:@""];
    [addField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger numOfSections =[[[TMListStore sharedStore] returnAllLists] count] + 1;
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section >=0 && section < [[[TMListStore sharedStore] returnAllLists] count])

    {
        if ([expandedSections containsIndex:section])
        {
            TMListItem *l = [[[TMListStore sharedStore] returnAllLists] objectAtIndex:section];
            NSInteger count =  [[[TMListStore sharedStore] getAllTasksFromList:l.title] count];
            return count+1;
            // return rows when expanded
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"CellIdentifier1";
    static NSString *CellIdentifier2 = @"CellIdentifier2";
    
    if ([indexPath compare:editingIndexPath] == NSOrderedSame) {
        TMListsViewEditableCell *editableCell = [tableView
                                                 dequeueReusableCellWithIdentifier:TMListsViewEditableCellIdentifier];
        [self setupEditableCell:editableCell
                       withText:[self listNameFromIndexPath:indexPath]];
        [editField performSelector:@selector(becomeFirstResponder)
                        withObject:nil
                        afterDelay:0.1f];
        return editableCell;
    }

    
    if (indexPath.section >= 0 && indexPath.section < [[[TMListStore sharedStore] returnAllLists] count]){
        UITableViewCell *cell;
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            }
            
            TMListItem *l = [[[TMListStore sharedStore] returnAllLists] objectAtIndex:indexPath.section];
            // Configure the cell
            //cell.textLabel.text = [listArray objectAtIndex: indexPath.section];
            cell.textLabel.text = l.title;
            
            //set font background to transparent
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            
            //add UILabel
            //UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 45.0, 200.0, 20.0)];
            //[subtitle setTextColor:[UIColor colorWithHue:1.0 saturation:1.0 brightness:1.0 alpha:0.5]];
            //[subtitle setBackgroundColor:[UIColor clearColor]];
            //[subtitle setFont:[UIFont systemFontOfSize:12.0]];
            //[subtitle setText:@"Add annotation"];
            //[cell addSubview:subtitle];
            
            //set background
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg.png"]]];
            
            //set right conjunction pic of the cell
            if (l.tasks.count > 0){
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                //if ([expandedSections containsIndex:indexPath.section])
                //{
                  //  cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lessInfo_22inch.png"]];
              //  }
                //else{
                    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moreInfo_22inch.png"]];
                //}
            }
            
        }else
        {
            cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            }
            TMListItem *l = [[[TMListStore sharedStore] returnAllLists] objectAtIndex:indexPath.section];
            TMTask *t = [[[TMListStore sharedStore] getAllTasksFromList:l.title] objectAtIndex:(indexPath.row -1)];
            cell.textLabel.text = t.title;
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            cell.accessoryView = nil;
           // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;

    }else
    {
        TMListsViewEditableCell *editableCell = [tableView dequeueReusableCellWithIdentifier:TMListsViewEditableCellIdentifier];
        addField = editableCell.titleField;
        addField.text = @"";
        [addField setPlaceholder:@"Add a new series"];
        addField.delegate = self;
        editableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return editableCell; 
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return 28.0;
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndexPath != nil && [selectedIndexPath compare: indexPath] == NSOrderedSame)
    {
        return listTableView.rowHeight * 2;
    }
    return listTableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (listTableView.isEditing){
        if (indexPath.section>0 && indexPath.row==0){
            [self endCellEdit];
            editingIndexPath = indexPath; 
            [listTableView reloadData];
        }
    }
    else{
        if (indexPath.section >=0 && indexPath.section < [[[TMListStore sharedStore] returnAllLists] count])
        {
            NSLog(@"indexPath.row: %d",indexPath.row);
            NSLog(@"indexPath.section %d",indexPath.section);
            if (!indexPath.row)
            {
                [listTableView deselectRowAtIndexPath:indexPath animated:YES];
                NSInteger section = indexPath.section;
                BOOL currentlyExpanded = [expandedSections containsIndex:section];
                NSInteger rows;
                NSMutableArray *tmpArray = [NSMutableArray array];
                
                if (currentlyExpanded){
                    rows = [self tableView:tableView numberOfRowsInSection:section];
                    [expandedSections removeIndex:section];
                }else{
                    [expandedSections addIndex:section];
                    rows = [self tableView:tableView numberOfRowsInSection:section];
                }
                for (int i=1; i<rows; i++){
                    NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                                   inSection:section];
                    [tmpArray addObject:tmpIndexPath];
                }
                if (currentlyExpanded){
                    if ([tmpArray count] > 0){
                        [listTableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
                    }
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moreInfo_22inch.png"]];
                }else{
                    if ([tmpArray count] > 0){
                        [listTableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
                    }
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lessInfo_22inch.png"]];
                }
                
            }
            else{
                [listTableView deselectRowAtIndexPath:indexPath animated:YES];
                TMListItem *l = [[[TMListStore sharedStore] returnAllLists] objectAtIndex:indexPath.section];
                TMTask *t = [[[TMListStore sharedStore] getAllTasksFromList:l.title] objectAtIndex:(indexPath.row -1)];
                [[[TMViewControllerStore sharedStore] returnTMtvc] updateWithTask:t];
                [[[TMViewControllerStore sharedStore] returnMenuController] showRootController:YES];
            }
        }
    }
    /*
    NSArray* toReload = [NSArray arrayWithObjects:indexPath,selectedIndexPath,nil];
    selectedIndexPath = indexPath;
    [listTableView reloadRowsAtIndexPaths:toReload withRowAnimation:UITableViewRowAnimationMiddle];
    */
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return @"Custom Lists";
    return nil;
}
*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        // create the parent view that will hold header Label
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 38.0)];
        UILabel *sectionTitle = [[UILabel alloc] init];
        sectionTitle.text = @"Customized Lists";
        sectionTitle.textColor = [UIColor whiteColor];
        sectionTitle.backgroundColor = [UIColor blackColor];
        sectionTitle.frame = CGRectMake(10.0,6.0,200,18);
        // create the button obje ct
        //UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        UIButton *headerBtn = [[UIButton alloc] init];
        headerButton = headerBtn;
        //headerBtn.backgroundColor = [UIColor whiteColor];
        //headerBtn.opaque = NO;
        headerBtn.frame = CGRectMake(240.0, 6.0, 30.0, 16.0);
        [headerBtn setBackgroundImage:[UIImage imageNamed:@"list_edit_btn_2.png"] forState:UIControlStateNormal];
        //[headerBtn setTitle:@"Edit" forState:UIControlStateNormal];
        //[headerBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:250/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
        //[headerBtn setBackgroundColor:[UIColor colorWithRed:64/255.0 green:59/255.0 blue:60/255.0 alpha:1.0]];
        
        [headerBtn addTarget:self action:@selector(ActionEventForEditButton) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:sectionTitle];
        [customView addSubview:headerBtn];
        
        return customView;

    }
    return nil;
}
- (void)ActionEventForEditButton
{
    [self toggleEdit];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= 1 && indexPath.section < [[[TMListStore sharedStore] returnAllLists] count])
        return YES;
    if (indexPath.section == 0 && indexPath.row>0)
        return YES;
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
       
        if (indexPath.row == 0){
            TMListStore *ls = [TMListStore sharedStore];
            NSArray *allLists = [ls returnAllLists];
            NSLog(@"IndexPath:%d section %d row",indexPath.section,indexPath.row);
            TMListItem *l = [allLists objectAtIndex:[indexPath section]];
            
            if (l.tasks.count > 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"This will delete all associated tasks"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Delete", nil];
                indexOfSeriesToBeDeleted = indexPath;
                [alert show];
            } else {
                [self deleteListAtIndexPath:indexPath];
            }
        }else{
            [self deleteTaskAtIndexPath:indexPath];
        }
    }

}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteListAtIndexPath:indexOfSeriesToBeDeleted];
        indexOfSeriesToBeDeleted = nil;
    }
    //[self toggleEdit];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == addField &&
        [[TMListStore sharedStore] listsByTitle:addField.text] != nil) {
        [self showIdenticalTitleWarning];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == addField) {
        [self addLists:addField.text];
        [listTableView reloadData];
        activeTextField = nil;
    } else if (textField == editField) {
        if (listTableView.isEditing)
            [self endCellEdit];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}
#pragma mark - Helper
-(UITableView *)returnListTableView
{
    return listTableView;
}
- (void)showIdenticalTitleWarning
{
    addField.text = @"";
    addField.placeholder = @"Please enter an UNIQUE title";
}
- (void)addLists:(NSString *)title
{
    if (![title isEqualToString:@""]){
        [[TMListStore sharedStore] createListWithTitle:title];
    }
}

- (void)deleteListAtIndexPath:(NSIndexPath *)indexPath
{
    [listTableView beginUpdates];
    TMListStore *ls = [TMListStore sharedStore];
    NSArray *allLists = [ls returnAllLists];
   // NSLog(@"IndexPath:%d section %d row",indexPath.section,indexPath.row);
    TMListItem *l = [allLists objectAtIndex:[indexPath section]];
    for (TMTask *task in l.tasks)
    {
        [[TMTaskStore sharedStore] removeTask:task];
    }
    
    [ls removeList:l];
    [listTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
             withRowAnimation:UITableViewRowAnimationFade];
    [listTableView endUpdates];
    //[self toggleEdit];
    
}

- (void)deleteTaskAtIndexPath:(NSIndexPath *)indexPath
{
    [listTableView beginUpdates];
    TMListStore *ls = [TMListStore sharedStore];
    TMListItem *l = [[ls returnAllLists] objectAtIndex:[indexPath section]];
    NSMutableArray *tasks = [ls getAllTasksFromList:l.title];
    TMTask *t = [tasks objectAtIndex:indexPath.row-1];
    NSLog(@"task:%@",t.title);
    TMTaskStore *ts = [TMTaskStore sharedStore];
    [ls removeTask:t FromList:l.title];
    [ts removeTask:t];
    [listTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [listTableView endUpdates];
    //[self toggleEdit];
    
}

-(void)toggleEdit{
    if (listTableView.isEditing){
        //[sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self endCellEdit];
        [headerButton setBackgroundImage:[UIImage imageNamed:@"list_edit_btn_2.png"] forState:UIControlStateNormal];
        [listTableView setEditing:NO animated:YES];
    }else{
        //[sender setTitle:@"Done" forState:UIControlStateNormal];
        [headerButton setBackgroundImage:[UIImage imageNamed:@"list_done_btn.png"] forState:UIControlStateNormal];
        [listTableView setEditing:YES animated:YES];
    }
}
- (void)setupEditableCell:(TMListsViewEditableCell *)cell withText:(NSString *)text
{
    editField = cell.titleField;
    
    editField.text = text;
    [editField setPlaceholder:@""];
    editField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)endCellEdit
{
    if (editingIndexPath == nil)
        return;
    
    NSString *newTitle = editField.text;
    
    NSUInteger listIdx = editingIndexPath.section;
    TMListItem *list = [[[TMListStore sharedStore] returnAllLists] objectAtIndex:listIdx];
    
    if (newTitle.length != 0 &&
        [[TMListStore sharedStore] listsByTitle:editField.text] == nil)
        list.title = newTitle;
    editingIndexPath = nil;
    [listTableView reloadData];
}
- (NSString *)listNameFromIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [[TMListStore sharedStore] returnAllLists].count)
    {TMListItem *list = [[[TMListStore sharedStore] returnAllLists]
                            objectAtIndex:(indexPath.section)];
        return list.title;
    }
    return nil;
}
#pragma mark - Scrolling Keyboard
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // Step 1: Get the size of the keyboard.
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    listTableView.contentInset = contentInsets;
    listTableView.scrollIndicatorInsets = contentInsets;
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    CGPoint pos = [activeTextField.superview convertPoint:activeTextField.frame.origin toView:nil];
    NSLog(@"addField frame origin: %f x %f y",pos.x, pos.y);
    if (!CGRectContainsPoint(aRect, pos) ) {
        CGPoint scrollPoint = CGPointMake(0.0, pos.y - (keyboardSize.height-20));
        [listTableView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    listTableView.contentInset = contentInsets;
    listTableView.scrollIndicatorInsets = contentInsets;
}
@end
