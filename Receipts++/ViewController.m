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

@property (weak, nonatomic) NSArray *objects;

@property (weak, nonatomic) Tag* tagFamily;
@property (weak, nonatomic) Tag* tagFriends;
@property (weak, nonatomic) Tag* tagGas;
@property (weak, nonatomic) Tag* tagCoffee;



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


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCustomCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Receipt *rec = self.objects[indexPath.row];
    
    myCell.amountLabel.text = [NSString stringWithFormat:@"%@",rec.amount];
    myCell.noteLabel.text = rec.note;
    myCell.timeLabel.text = [NSString stringWithFormat:@"%@", rec.timeStamp];
    
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
