//
//  PatientDetailsViewController.h
//  ToddsSyndromeApp
//
//  Created by Marija Djuric on 03/10/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "Patient+CoreDataProperties.m"
#import "PatientService.h"

@interface PatientDetailsViewController : UIViewController <PatientServiceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearOfBirthTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *drugsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *migrainesSwitch;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) Patient * patient;
@end
