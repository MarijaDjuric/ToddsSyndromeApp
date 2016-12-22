//
//  PatientDetailsViewController.m
//  ToddsSyndromeApp
//
//  Created by Marija Djuric on 03/10/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import "PatientDetailsViewController.h"

@implementation PatientDetailsViewController

@synthesize patient;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpGui];
    [self setNavigationBar];
    [PatientService sharedInstance].delegate = self;

    
}

-(void) setUpGui{
    if (self.patient) {
        [self.nameTextField setText:self.patient.name];
        [self.surnameTextField setText:self.patient.surname];
        [self.yearOfBirthTextField setText:[NSString stringWithFormat:@"%ld", self.patient.yearOfBirth.integerValue]];
        self.genderSegmentedControl.selectedSegmentIndex = [self.patient.gender isEqualToString:@"MALE"]? 0: 1;
        self.drugsSwitch.on = [self.patient.usedDrugs boolValue];
        self.migrainesSwitch.on = [self.patient.haveMigraines boolValue];
        [self.resultLabel setText: [NSString stringWithFormat:@"Result: %@%%", self.patient.probabilityForTSyndrome]];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - Private methods

-(void)setNavigationBar
{
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"  style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
   
}


#pragma  mark - Action methods

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    

    NSString *name = self.nameTextField.text;
    NSString *surname = self.surnameTextField.text;
    NSNumber *yearOfBirth = [NSNumber numberWithInteger: [self.yearOfBirthTextField.text integerValue]];
    NSNumber *haveMigraines = [NSNumber numberWithBool: self.migrainesSwitch.isOn];
    NSNumber *usedDrugs = [NSNumber numberWithBool: self.drugsSwitch.isOn];
    NSString *gender = self.genderSegmentedControl.selectedSegmentIndex == 0? @"MALE":@"FEMALE";
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSInteger year = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    NSInteger numberOfYear = (year - [yearOfBirth integerValue]);
    
    if(name.length && surname.length && numberOfYear >= 0){
        if(self.patient){
            self.patient.name = name;
            self.patient.surname = surname;
            self.patient.gender = gender;
            self.patient.yearOfBirth = yearOfBirth;
            self.patient.usedDrugs = usedDrugs;
            self.patient.haveMigraines = haveMigraines;
            [[PatientService sharedInstance] savePatient:self.patient];
        }else{
            [[PatientService sharedInstance] saveNewPatientWithName:name andSurname:surname andYearOfBirth:yearOfBirth andGender:gender areUseDrugs:usedDrugs haveMigranes:haveMigraines];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please fill all data correctly" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    


}

#pragma mark - PatientServiceDelegate

-(void)patientSaved:(Patient *)patientEntity{
    self.patient = patientEntity;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Patient's data saved" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    [self setUpGui];
    
}

-(void)patientSavingFailed:(NSError *)error{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Some error occurred, please check your data" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
