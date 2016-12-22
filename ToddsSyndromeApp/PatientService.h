//
//  PatientService.h
//  ToddsSyndromeApp
//
//  Created by Marija Djuric on 03/10/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Patient.h"
#import "Patient+CoreDataProperties.h"
#import "AppDelegate.h"

@protocol PatientServiceDelegate <NSObject>

@optional
- (void) patientSaved:(Patient *)patient;
- (void) patientSavingFailed:(NSError *)error;

@end

@interface PatientService : NSObject

@property (strong, nonatomic) id<PatientServiceDelegate> delegate;

+ (PatientService *)sharedInstance;

- (NSMutableArray *)getAllPatients;

- (void)saveNewPatientWithName:(NSString *) name andSurname:(NSString *)surname andYearOfBirth:(NSNumber *)yearOgBirth andGender:(NSString *)gender areUseDrugs:(NSNumber *) areUseDrugs haveMigranes:(NSNumber *) haveMigraines;

- (void)savePatient:(Patient *)patient;

- (void)deletePatient:(Patient *)patient;
@end
