//
//  PatientsViewController.m
//  ToddsSyndromeApp
//
//  Created by Marija Djuric on 03/10/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import "PatientsViewController.h"
#import "Patient.h"
#import "PatientDetailsViewController.h"

@interface PatientsViewController()

@property (strong, nonatomic) NSMutableArray *patients;

@end


@implementation PatientsViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the patients from persistent data store
  
    self.patients = [[PatientService sharedInstance] getAllPatients];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.patients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Patient *patient = [self.patients objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", patient.name, patient.surname]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%%", patient.probabilityForTSyndrome]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
        [[PatientService sharedInstance] deletePatient:[self.patients objectAtIndex:indexPath.row]];
        // Remove patient from table view
        [self.patients removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    Patient *patient = [self.patients objectAtIndex:indexPath.row];
    PatientDetailsViewController *patientDetailsViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"patientDetailsViewController"];
    patientDetailsViewController.patient = patient;
    [self.navigationController pushViewController:patientDetailsViewController animated:YES];
}

#pragma mark - Action methods

- (IBAction)addNewPatient:(id)sender {
    
    PatientDetailsViewController *patientDetailsViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"patientDetailsViewController"];
    [self.navigationController pushViewController:patientDetailsViewController animated:YES];
}



@end
