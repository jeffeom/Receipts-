//
//  AddNewReceiptsViewController.h
//  Receipts++
//
//  Created by Jeff Eom on 2016-07-21.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reciept+CoreDataProperties.h"
#import "Tag+CoreDataProperties.h"

@protocol AddNewReceiptsViewControllerDelegate <NSObject>

-(void)pressedButtonToSendAmountInput:(NSNumber *)amountInput NoteInput:(NSString *)noteInput TimeInput:(NSDate *)timeInput andTagArray:(NSArray *)tagArray;

@end

@interface AddNewReceiptsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *amountInput;
@property (weak, nonatomic) IBOutlet UITextField *noteInput;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITableView *tagTable;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (weak, nonatomic) id <AddNewReceiptsViewControllerDelegate> delegate;
@property (nonatomic) NSInteger selectedCell;

@end
