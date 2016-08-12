//
//  AddNewReceiptsViewController.m
//  Receipts++
//
//  Created by Jeff Eom on 2016-07-21.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

#import "AddNewReceiptsViewController.h"
#import "AppDelegate.h"

@interface AddNewReceiptsViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSArray *objects;
@property NSMutableArray *mySelectedTags;
@property NSIndexPath *selectedIndexPath;

@end

@implementation AddNewReceiptsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    [self fetchDataTag];
    // Do any additional setup after loading the view.
    self.tagTable = [[UITableView alloc] init];
//    self.myTagsArray = @[@"Family", @"Friends", @"Gas", @"Coffee"];
    self.mySelectedTags = [NSMutableArray array];

}

#pragma mark - Button

- (IBAction)saveButton:(id)sender {
    
    NSLog(@"Save Button is Pressed");
    
    [self.delegate pressedButtonToSendAmountInput:[NSNumber numberWithInt: (int)[self.amountInput.text integerValue]] NoteInput:self.noteInput.text TimeInput:self.datePicker.date andTagArray:self.mySelectedTags];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Fetch Tag Data

-(void)fetchDataTag {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    
    NSError *error;
    self.objects = [self.context executeFetchRequest:fetchRequest error:&error];
}


#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.objects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self fetchDataTag];
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
    Tag *tag = self.objects[indexPath.row];
    myCell.textLabel.text = tag.tagName;
    
    return myCell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Category";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.selectedIndexPath && (indexPath == self.selectedIndexPath)) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [tableView cellForRowAtIndexPath:self.selectedIndexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.mySelectedTags removeObject:self.objects[indexPath.row]];
        self.selectedIndexPath = nil;
    }
    else {
        NSLog(@"cell is selected");
        self.selectedIndexPath = indexPath;
        [tableView cellForRowAtIndexPath:self.selectedIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.mySelectedTags addObject:self.objects[indexPath.row]];
        NSLog(@"this is my tag: %@", [self.mySelectedTags componentsJoinedByString:@" "]);
    }
}
@end
