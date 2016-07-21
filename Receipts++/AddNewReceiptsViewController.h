//
//  AddNewReceiptsViewController.h
//  Receipts++
//
//  Created by Jeff Eom on 2016-07-21.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewReceiptsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *amountInput;
@property (weak, nonatomic) IBOutlet UITextField *noteInput;
@property (weak, nonatomic) IBOutlet UITextField *timeInput;
@property (weak, nonatomic) IBOutlet UITableView *tagTable;

@end
