//
//  ViewController.m
//  Receipts++
//
//  Created by Jeff Eom on 2016-07-21.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

#import "ViewController.h"
#import "AddNewReceiptsViewController.h"
#import "MyCustomCell.h"
#import "Reciept+CoreDataProperties.h"
#import "Tag+CoreDataProperties.h"
@import CoreData;

@interface ViewController () <AddNewReceiptsViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) NSArray *tags;

@end

@implementation ViewController

#pragma mark - Protocol

-(void)pressedButtonToSendAmountInput:(NSNumber *)amountInput NoteInput:(NSString *)noteInput TimeInput:(NSDate *)timeInput andTagArray:(NSArray *)tagArray{
    
    Receipt *myReceipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:self.context];
    
    myReceipt.amount = amountInput;
    myReceipt.note = noteInput;
    myReceipt.timeStamp = timeInput;
    
    [myReceipt addTags:[NSSet setWithArray: tagArray]];
    
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Error saving cd %@", error);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self fetchDataTags];
    [self fetchDataReceipt];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchDataReceipt];
    [self.tableView reloadData];
}


-(void)fetchDataReceipt {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Receipt"];
    
    NSError *error;
    self.objects = [self.context executeFetchRequest:fetchRequest error:&error];
}

-(void)fetchDataTags {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    
    NSError *error;
    self.tags = [self.context executeFetchRequest:fetchRequest error:&error];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.objects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.tags count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *tagNames = [NSMutableArray array];
    
    for (Tag *aTag in self.tags) {
        [tagNames addObject:aTag.tagName];
    }
    
    return tagNames[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCustomCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Receipt *rec = self.objects[indexPath.row];
    
    myCell.amountLabel.text = [NSString stringWithFormat:@"$%@",rec.amount];
    myCell.noteLabel.text = rec.note;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMMM dd, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:rec.timeStamp];
    myCell.timeLabel.text = [NSString stringWithFormat:@"%@", prettyVersion];
    
    NSArray *tags = rec.tags.allObjects;
    NSMutableArray *tagNames = [NSMutableArray array];
    for (Tag *tag in tags) {
        [tagNames addObject:tag.tagName];
    }
    myCell.tagLabel.text = [NSString stringWithFormat:@"%@", [tagNames componentsJoinedByString:@" "]];
    
    return myCell;
}



- (IBAction)insertNewObject:(id)sender {
    
    AddNewReceiptsViewController *addingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"newView"];
    
    addingPage.delegate = self;
    
    [self.navigationController pushViewController:addingPage animated:YES];
}

@end
