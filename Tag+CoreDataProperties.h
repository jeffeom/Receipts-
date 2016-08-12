//
//  Tag+CoreDataProperties.h
//  Receipts++
//
//  Created by Jeff Eom on 2016-07-21.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tag.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tagName;
@property (nullable, nonatomic, retain) NSSet<Reciept *> *receipts;

@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(Reciept *)value;
- (void)removeReceiptsObject:(Reciept *)value;
- (void)addReceipts:(NSSet<Reciept *> *)values;
- (void)removeReceipts:(NSSet<Reciept *> *)values;

@end

NS_ASSUME_NONNULL_END
