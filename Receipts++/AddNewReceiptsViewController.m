//
//  AddNewReceiptsViewController.m
//  Receipts++
//
//  Created by Jeff Eom on 2016-07-21.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

#import "AddNewReceiptsViewController.h"

@interface AddNewReceiptsViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSArray *myTagsArray;
@property NSMutableArray *countSelectedTags;
@property NSIndexPath *selectedIndexPath;

@end

@implementation AddNewReceiptsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tagTable = [[UITableView alloc] init];
    self.myTagsArray = @[@"Family", @"Friends", @"Gas", @"Coffee"];
    self.countSelectedTags = [NSMutableArray array];

}

#pragma mark - Button

- (IBAction)saveButton:(id)sender {
    
    NSLog(@"Save Button is Pressed");
    
    [self.delegate pressedButtonToSendAmountInput:[NSNumber numberWithInt: (int)[self.amountInput.text integerValue]] NoteInput:self.noteInput.text TimeInput:self.datePicker.date andTagTable:self.tagTable];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myTagsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
    
    myCell.textLabel.text = self.myTagsArray[indexPath.row];
    
    return myCell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Category";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.selectedIndexPath && (indexPath == self.selectedIndexPath)) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [tableView cellForRowAtIndexPath:self.selectedIndexPath].accessoryType = UITableViewCellAccessoryNone;
        NSNumber *row = [NSNumber numberWithInteger:myCell.tag];
        [self.countSelectedTags removeObject:row];
        self.selectedIndexPath = nil;
    }
    else {
        NSLog(@"cell is selected");
        self.selectedIndexPath = indexPath;
        [tableView cellForRowAtIndexPath:self.selectedIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        myCell.tag = indexPath.row;
        NSNumber *row = [NSNumber numberWithInteger:myCell.tag];
        [self.countSelectedTags addObject:row];
        NSLog(@"this is my tag number: %ld", (long)myCell.tag);
    }
}
@end
