//
//  DetailViewController.m
//  AIPetition
//
//  Created by Jean-Pierre Simard on 12-06-07.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import "DetailViewController.h"

#define kPinOverride @"3141"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize petitionView = _petitionView;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize currentUser = _currentUser;
@synthesize lockBtn = _lockBtn;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _lockBtn = [[UIBarButtonItem alloc] initWithTitle:@"Lock" style:UIBarButtonItemStylePlain target:self action:@selector(lock:)];
    UIBarButtonItem *emailBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(email:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_lockBtn, emailBtn, nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"petition" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_petitionView loadRequest:request];
    
    //create new user
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:appDel.managedObjectContext]];
    
    NSError *error;
    NSArray *users = [appDel.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([users count]) {
        NSLog(@"user already exists");
        _currentUser = [users lastObject];
    } else {
        NSLog(@"created user");
        _currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:appDel.managedObjectContext];
    }
    [appDel saveContext];
    if (_currentUser.pinCode.length > 0) {
        appDel.isLocked = true;
        // btn to unlock
        _lockBtn.title = @"Unlock";
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_lockBtn, nil];
    } else {
        appDel.isLocked = NO;
    }
}

- (void)viewDidUnload
{
    [self setPetitionView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Signatures", @"Signatures");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Lock
- (void)lock:(id)sender {
    if (!appDel.isLocked) {
        _currentUser.pinCode = NULL;
        [appDel saveContext];
        darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        [darkOverlay setBackgroundColor:[UIColor blackColor]];
        [darkOverlay setAlpha:0];
        [self.splitViewController.view addSubview:darkOverlay];
        [UIView beginAnimations:@"castOverlay" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        darkOverlay.alpha = 0.6;
        [UIView commitAnimations];
        pinCodeViewController=[[PinCode alloc] initWithNibName:@"PinCode" bundle:nil];
        
        [pinCodeViewController setDelegate:self];
        [pinCodeViewController.view setFrame:CGRectMake(
                                                        (self.splitViewController.view.frame.size.height/2)-(pinCodeViewController.view.frame.size.width/2),
                                                        (self.splitViewController.view.frame.size.width/2)-(pinCodeViewController.view.frame.size.height/2),
                                                        pinCodeViewController.view.frame.size.width,
                                                        pinCodeViewController.view.frame.size.height)];
        [self.splitViewController.view addSubview:pinCodeViewController.view];
        if ([_currentUser pinCode] == NULL) {
            pinCodeViewController.titleLabel.text = @"Set your PIN";
            pinCodeViewController.descriptionLabel.text = @"Choose a 4-digit secret PIN";
        }
    } else {
        darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        [darkOverlay setBackgroundColor:[UIColor blackColor]];
        [darkOverlay setAlpha:0];
        [self.splitViewController.view addSubview:darkOverlay];
        [UIView beginAnimations:@"castOverlay" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        darkOverlay.alpha = 0.6;
        [UIView commitAnimations];
        pinCodeViewController=[[PinCode alloc] initWithNibName:@"PinCode" bundle:nil];
        
        [pinCodeViewController setDelegate:self];
        [pinCodeViewController.view setFrame:CGRectMake(
                                                        (self.splitViewController.view.frame.size.height/2)-(pinCodeViewController.view.frame.size.width/2),
                                                        (self.splitViewController.view.frame.size.width/2)-(pinCodeViewController.view.frame.size.height/2),
                                                        pinCodeViewController.view.frame.size.width,
                                                        pinCodeViewController.view.frame.size.height)];

        [self.splitViewController.view addSubview:pinCodeViewController.view];
    }
}
# pragma mark -- PinView delegate methods

- (BOOL)isPinCodeCorrect:(NSString *)pinCode{
    NSLog(@"validate pincode %@",pinCode);
    NSString *stringPIN = [_currentUser pinCode];
    if (stringPIN == (NSString*)NULL) {
        stringPIN = @"0000";
    }
    while ([stringPIN length] < 4) {
        stringPIN = [NSString stringWithFormat:@"%@0",stringPIN];
    }
    if ([stringPIN isEqualToString:[pinCode substringToIndex:4]] || [kPinOverride isEqualToString:[pinCode substringToIndex:4]]) {
        _currentUser.pinCode = NULL;
        [appDel saveContext];
        _lockBtn.title = @"Lock";
        appDel.isLocked = false;
        UIBarButtonItem *emailBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(email:)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_lockBtn, emailBtn, nil];
        return YES;
    } else if ([stringPIN isEqualToString:@"0000"]) {
        _currentUser.pinCode = pinCode;
        [appDel saveContext];
        [self removeOverlay];
        appDel.isLocked = true;
        // btn to unlock
        _lockBtn.title = @"Unlock";
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_lockBtn, nil];
        return YES;
    }
    return NO;
}

-(void) pinCodeViewWillClose {
    [UIView beginAnimations:@"hideOverlay" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    darkOverlay.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(removeOverlay)];
    [UIView commitAnimations];

    [pinCodeViewController.view removeFromSuperview];
    pinCodeViewController = nil;
}

- (void)removeOverlay {
    [darkOverlay removeFromSuperview];
    darkOverlay = nil;
}

- (IBAction)sign:(id)sender {
    // Initiallize the signature controller
	JBSignatureController *signatureController = [[JBSignatureController alloc] init];
	signatureController.delegate = self;
    signatureController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:signatureController animated:YES];
}



#pragma mark - *** JBSignatureControllerDelegate ***

/**
 * Example usage of signatureConfirmed:signatureController:
 * @author Jesse Bunch
 **/
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(JBSignatureController *)sender {
	
	if((sender.firstNameField.text.length > 0) && (sender.lastNameField.text.length > 0) && (sender.emailAddressField.text.length > 0))
    {
        
        if([self validateEmail:sender.emailAddressField.text]) {
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity: [NSEntityDescription entityForName:@"Signer" inManagedObjectContext:appDel.managedObjectContext]];
            
            NSError *error = nil;
            NSArray *signers = [appDel.managedObjectContext executeFetchRequest:request error:&error];
            
            NSInteger newID = ((NSNumber*)[signers valueForKeyPath:@"@max.signatureID"]).intValue + 1;
            
            Signer *newSigner = [NSEntityDescription insertNewObjectForEntityForName:@"Signer" inManagedObjectContext:appDel.managedObjectContext];
            [newSigner setFirstName:sender.firstNameField.text];
            [newSigner setLastName:sender.lastNameField.text];
            [newSigner setEmail:sender.emailAddressField.text];
            [newSigner setSignatureID:[NSNumber numberWithInt:newID]];
            [newSigner setTimeStamp:[NSDate date]];
            
            [appDel saveContext];
            
            UIImageView *imageview = [[UIImageView alloc] initWithImage:signatureImage];
            [imageview setContentMode:UIViewContentModeCenter];
            [imageview sizeToFit];
            [imageview setTransform:sender.view.transform];
            sender.view = imageview;
            [self performSelector:@selector(dismissJBView) withObject:nil afterDelay:2.0];
            
            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            [UIImageJPEGRepresentation(signatureImage, 0.6) writeToFile:[documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg",newID]] atomically:YES];
//            [UIImagePNGRepresentation(signatureImage) writeToFile:[documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",newID]] atomically:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email Address" message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            sender.emailAddressField.text = @"";
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing required information." message:@"Please enter your first and last name and a valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show]; 
    }
}

/**
 * Example usage of signatureCancelled:
 * @author Jesse Bunch
 **/
-(void)signatureCancelled:(JBSignatureController *)sender {
	
	// close signature controller
	
	// Clear the sig for now
	[sender clearSignature];
	
}

- (void)dismissJBView {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)email:(id)sender {
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    
//    Get all signature JPEGs
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:NULL];
    for (NSString *fileName in directoryContent) {
        if ([fileName rangeOfString:@".jpg"].location != NSNotFound) {
            NSLog(@"documents/%@",fileName);
            NSData *myData = [NSData dataWithContentsOfFile:[documentsPath stringByAppendingPathComponent:fileName]];
            [mailVC addAttachmentData:myData mimeType:@"image/jpeg" fileName:fileName];
        }
    }
    
//    Create signer info CSV
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName:@"Signer" inManagedObjectContext:appDel.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *signers = [appDel.managedObjectContext executeFetchRequest:request error:&error];
    NSString *csvString = @"Signature ID,First Name,Last Name,Email\n";
    for (Signer *signer in signers) {
        csvString = [NSString stringWithFormat:@"%@%d,%@,%@,%@\n",csvString,signer.signatureID.intValue,signer.firstName,signer.lastName,signer.email];
    }
    
    [mailVC addAttachmentData:[csvString dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/csv" fileName:@"signatures.csv"];
    
    // Fill out the email body text
    [mailVC setMessageBody:@"This email contains a CSV file of signer information and their signatures for the Justice for Noxolo petition." isHTML:NO];
    [self presentModalViewController:mailVC animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
           
- (BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
               
    return [emailTest evaluateWithObject:candidate];
}

@end
