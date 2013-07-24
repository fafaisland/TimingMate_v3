//
//  TMListViewController.h
//  TimingMate_v2
//
//  Created by easonfafa on 6/25/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMListViewController : UIViewController
<UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *listTableView;
    UIButton *headerButton;
    
    UITextField *activeTextField;
    
    __weak UITextField *editField;
    __weak UITextField *addField;
    
    NSIndexPath *indexOfSeriesToBeDeleted;
    NSIndexPath *editingIndexPath;
    
    NSMutableIndexSet *expandedSections;
}
-(UITableView *)returnListTableView;
@property (retain) NSIndexPath* selectedIndexPath;

@end
