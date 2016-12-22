//
//  PatientService.m
//  ToddsSyndromeApp
//
//  Created by Marija Djuric on 03/10/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import "PatientService.h"

@interface PatientService()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation PatientService

static PatientService *sharedInstance;

+ (PatientService *)sharedInstance
{
    if (!sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[PatientService alloc] init];
        });
        
    }
    
    return sharedInstance;
}

#pragma mark - setup

- (id)init
{
    self = [super init];
    
    if (self) {
        _managedObjectContext = [self managedObjectContext];

    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - Public methods
- (NSMutableArray *)getAllPatients{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Patient"];
    NSError * error;
    NSMutableArray *result = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return result;
    
}

- (void)saveNewPatientWithName:(NSString *) name andSurname:(NSString *)surname andYearOfBirth:(NSNumber *)yearOgBirth andGender:(NSString *)gender areUseDrugs:(NSNumber *) areUseDrugs haveMigranes:(NSNumber *) haveMigraines{
    
    Patient *newPatient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
    newPatient.name = name;
    newPatient.surname = surname;
    newPatient.yearOfBirth =  yearOgBirth;
    newPatient.gender = gender;
    newPatient.usedDrugs = areUseDrugs;
    newPatient.haveMigraines = haveMigraines;
    
    [self savePatient:newPatient];
}
- (void)savePatient:(Patient *)patient{

    
    patient.probabilityForTSyndrome = [self calculateProbabilityForSindrome:patient];
    NSError *error = nil;
    // Save the object to persistent store
    if (![self.managedObjectContext save:&error]) {
        [self.delegate patientSavingFailed:error];
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
        [self.delegate patientSaved:patient];
    }
    
}

- (void) deletePatient:(Patient *)patient{
    [self.managedObjectContext deleteObject:patient];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        
        return;
    }
}

#pragma mark - Private methods

- (NSNumber *)calculateProbabilityForSindrome:(Patient *)patient{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSInteger year = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    NSInteger numberOfYear = (year - [patient.yearOfBirth integerValue]);
    
    NSNumber* isMen = [NSNumber numberWithBool:[patient.gender isEqualToString:@"MALE"]];
   
    double propability = ([patient.haveMigraines integerValue] + [patient.usedDrugs integerValue] + [isMen integerValue] + (numberOfYear <= 15? 1:0)) * 100 / 4.0 ;
    
    return [NSNumber numberWithDouble:propability];
}

@end
