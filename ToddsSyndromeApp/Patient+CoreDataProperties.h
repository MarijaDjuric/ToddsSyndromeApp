//
//  Patient+CoreDataProperties.h
//  ToddsSyndromeApp
//
//  Created by Marija Djuric on 03/10/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Patient.h"

NS_ASSUME_NONNULL_BEGIN

@interface Patient (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSNumber *haveMigraines;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *probabilityForTSyndrome;
@property (nullable, nonatomic, retain) NSString *surname;
@property (nullable, nonatomic, retain) NSNumber *usedDrugs;
@property (nullable, nonatomic, retain) NSNumber *yearOfBirth;

@end

NS_ASSUME_NONNULL_END
