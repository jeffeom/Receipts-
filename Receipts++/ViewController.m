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

@property (strong, nonatomic) NSArray *receipts;
@property (strong, nonatomic) NSArray *tags;

@property (strong, nonatomic) NSMutableArray *gas;
@property (strong, nonatomic) NSMutableArray *coffee;
@property (strong, nonatomic) NSMutableArray *family;
@property (strong, nonatomic) NSMutableArray *friends;

@property (strong, nonatomic) NSArray *organizedArray;

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

#pragma mark - viewDidLoad, viewWillAppear

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gas = [NSMutableArray array];
    self.coffee = [NSMutableArray array];
    self.family = [NSMutableArray array];
    self.friends = [NSMutableArray array];
    
    self.organizedArray = [NSArray array];
    
    [self fetchDataTags];
    [self fetchDataReceipt];
    [self reorganizeArray];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchDataReceipt];
    [self reorganizeArray];
    [self.tableView reloadData];
}

#pragma mark - Fetch Data

-(void)fetchDataReceipt {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Receipt"];
    
    NSError *error;
    self.receipts = [self.context executeFetchRequest:fetchRequest error:&error];
}

-(void)fetchDataTags {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    
    NSError *error;
    self.tags = [self.context executeFetchRequest:fetchRequest error:&error];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.organizedArray[section] count];
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
    
    Receipt *rec = self.organizedArray[indexPath.section][indexPath.row];
    NSArray *tags = rec.tags.allObjects;
    
    myCell.amountLabel.text = [NSString stringWithFormat:@"$%@",rec.amount];
    myCell.noteLabel.text = rec.note;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMMM dd, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:rec.timeStamp];
    myCell.timeLabel.text = [NSString stringWithFormat:@"%@", prettyVersion];
    
    myCell.tagLabel.text = [self listTagNames:tags];
    
    return myCell;
}


- (IBAction)insertNewObject:(id)sender {
    
    AddNewReceiptsViewController *addingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"newView"];
    
    addingPage.delegate = self;
    
    [self.navigationController pushViewController:addingPage animated:YES];
}

#pragma mark - Custom Methods

- (NSString *)listTagNames:(NSArray *)tagArray{
    
    NSMutableArray *tagNames = [NSMutableArray array];
    for (Tag *tag in tagArray) {
        [tagNames addObject:tag.tagName];
    }
    
    return [NSString stringWithFormat:@"%@", [tagNames componentsJoinedByString:@" "]];
}

- (void)reorganizeArray{
    [self resetArrays];
    [self createAnOrganizedArray];
}

-(void)createAnOrganizedArray{
    for (Receipt *aReceipt in self.receipts) {
        NSSet *tagSet = aReceipt.tags;
        
        for (Tag *aTag in tagSet) {
            if ([aTag.tagName isEqualToString: @"Gas"]) {
                [self.gas addObject:aReceipt];
            }else if([aTag.tagName isEqualToString:@"Coffee"]){
                [self.coffee addObject:aReceipt];
            }else if ([aTag.tagName isEqualToString: @"Family"]){
                [self.family addObject:aReceipt];
            }else{
                [self.friends addObject:aReceipt];
            }
        }
    }
    self.organizedArray = @[self.family, self.gas, self.friends, self.coffee];
}

-(void)resetArrays{
    self.gas = [NSMutableArray array];
    self.coffee = [NSMutableArray array];
    self.family = [NSMutableArray array];
    self.friends = [NSMutableArray array];
    self.organizedArray = [NSArray array];
}

@end
