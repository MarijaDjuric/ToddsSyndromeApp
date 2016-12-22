//
//  ToddsSyndromeAppTests.m
//  ToddsSyndromeAppTests
//
//  Created by Marija Djuric on 03/10/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "Patient+CoreDataProperties.h"

@interface ToddsSyndromeAppTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *moc;

@end

@implementation ToddsSyndromeAppTests

- (void)setUp {
    [super setUp];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ToddsSyndromeApp" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = psc;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testCreateNew
{
    Patient *newPatient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.moc];
    newPatient.name = @"Marija";
    newPatient.surname = @"Djuric";
    newPatient.yearOfBirth = [NSNumber numberWithInteger:1991];
    newPatient.gender = @"FEMALE";
    newPatient.usedDrugs = [NSNumber numberWithBool:NO];
    newPatient.haveMigraines = [NSNumber numberWithBool:NO];
    newPatient.probabilityForTSyndrome = [NSNumber numberWithDouble:0.0];
    
    // Save the context.
    NSError *error = nil;
    if (![self.moc save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
    XCTAssertFalse(self.moc.hasChanges,"All the changes should be saved");
}
@end
