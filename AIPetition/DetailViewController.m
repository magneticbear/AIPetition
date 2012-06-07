//
//  DetailViewController.m
//  AIPetition
//
//  Created by Jean-Pierre Simard on 12-06-07.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import "DetailViewController.h"
#import "NSFileManager+DirectoryLocations.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize petitionView = _petitionView;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

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
    UIBarButtonItem *lockBtn = [[UIBarButtonItem alloc] initWithTitle:@"Lock" style:UIBarButtonItemStylePlain target:self action:@selector(lock:)];
    UIBarButtonItem *emailBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(email:)];
//    self.navigationItem.rightBarButtonItem = lockBtn;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:lockBtn, emailBtn, nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"petition" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_petitionView loadRequest:request];
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
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
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
//    if ([self.currentUser pinCode] == NULL) {
        pinCodeViewController=[[PinCode alloc] initWithNibName:@"PinCode" bundle:nil];
        
        [pinCodeViewController setDelegate:self];
    pinCodeViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:pinCodeViewController animated:NO];
//        [pinCodeViewController.view setCenter:self.view.center];
//        [self.view addSubview:pinCodeViewController.view];
//        if ([self.currentUser pinCode] == NULL) {
//            pinCodeViewController.titleLabel.text = @"Set your PIN";
//            pinCodeViewController.descriptionLabel.text = @"Choose a 4-digit secret PIN";
//        }
//    } else {
//        if (isLocked) {
//            darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
//            [darkOverlay setBackgroundColor:[UIColor blackColor]];
//            [darkOverlay setAlpha:0];
//            [self.view addSubview:darkOverlay];
//            [UIView beginAnimations:@"castOverlay" context:nil];
//            [UIView setAnimationDelegate:self];
//            [UIView setAnimationDuration:0.3];
//            darkOverlay.alpha = 0.6;
//            [UIView commitAnimations];
//            pinCodeViewController=[[PinCode alloc] initWithNibName:@"PinCode" bundle:nil];
//            
//            [pinCodeViewController setDelegate:self];
//            [pinCodeViewController.view setFrame:CGRectMake(
//                                                            (self.view.frame.size.height/2)-(pinCodeViewController.view.frame.size.width/2),
//                                                            (self.view.frame.size.width/2)-(pinCodeViewController.view.frame.size.height/2),
//                                                            pinCodeViewController.view.frame.size.width,
//                                                            pinCodeViewController.view.frame.size.height)];
//            [self.view addSubview:pinCodeViewController.view];
//        } else {
//            [self removeOverlay];
//            isLocked = true;
//            [lockBtn setImage:[UIImage imageNamed:@"Lock.png"] forState:UIControlStateNormal];
//            [UIView beginAnimations:@"showAdminBar" context:nil];
//            [UIView setAnimationDelegate:self];
//            [UIView setAnimationDuration:0.5];
//            [favoritesLayer setAlpha:0];
//            breadcrumbBar.frame = CGRectMake(breadcrumbBar.frame.origin.x, breadcrumbBar.frame.origin.y-ADMIN_OFFSET, breadcrumbBar.frame.size.width, breadcrumbBar.frame.size.width);
//            mainContentView.frame = CGRectMake(mainContentView.frame.origin.x, mainContentView.frame.origin.y-ADMIN_OFFSET, mainContentView.frame.size.width, mainContentView.frame.size.height);
//            profilePicView.frame = CGRectMake(profilePicView.frame.origin.x, profilePicView.frame.origin.y-ADMIN_OFFSET, profilePicView.frame.size.width, profilePicView.frame.size.height);
//            mainContentScrollView.frame = CGRectMake(mainContentScrollView.frame.origin.x, mainContentScrollView.frame.origin.y, mainContentScrollView.frame.size.width, mainContentScrollView.frame.size.height+ADMIN_OFFSET);
//            adminBar.alpha = 0;
//            [UIView commitAnimations];
//        }
//    }
}
# pragma mark -- PinView delegate methods

-(BOOL) isPinCodeCorrect:(NSString *)pinCode{
    NSLog(@"pinCode is %@", pinCode);
    [self dismissModalViewControllerAnimated:NO];
//    NSString *stringPIN = [self.currentUser pinCode].stringValue;
//    if (stringPIN == (NSString*)NULL) {
//        stringPIN = @"0000";
//    }
//    while ([stringPIN length] < 4) {
//        stringPIN = [NSString stringWithFormat:@"%@0",stringPIN];
//    }
//    if ([stringPIN isEqualToString:[pinCode substringToIndex:4]]) {
//        isLocked = false;
//        [lockBtn setImage:[UIImage imageNamed:@"Lock2.png"] forState:UIControlStateNormal];
//        [UIView beginAnimations:@"hideAdminBar" context:nil];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDuration:0.5];
//        [favoritesLayer setAlpha:1];
//        breadcrumbBar.frame = CGRectMake(breadcrumbBar.frame.origin.x, breadcrumbBar.frame.origin.y+ADMIN_OFFSET, breadcrumbBar.frame.size.width, breadcrumbBar.frame.size.width);
//        mainContentView.frame = CGRectMake(mainContentView.frame.origin.x, mainContentView.frame.origin.y+ADMIN_OFFSET, mainContentView.frame.size.width, mainContentView.frame.size.height);
//        profilePicView.frame = CGRectMake(profilePicView.frame.origin.x, profilePicView.frame.origin.y+ADMIN_OFFSET, profilePicView.frame.size.width, profilePicView.frame.size.height);
//        mainContentScrollView.frame = CGRectMake(mainContentScrollView.frame.origin.x, mainContentScrollView.frame.origin.y, mainContentScrollView.frame.size.width, mainContentScrollView.frame.size.height-ADMIN_OFFSET);
//        adminBar.alpha = 1;
//        [UIView commitAnimations];
//        return YES;
//    } else if ([stringPIN isEqualToString:@"0000"]) {
//        currentUser.pinCode = [NSNumber numberWithInteger:[pinCode intValue]];
//        [self saveContext];
//        [self lock:self];
//        return YES;
//    }
    return NO;
}

-(void) pinCodeViewWillClose{
//    [UIView beginAnimations:@"hideOverlay" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:0.3];
//    darkOverlay.alpha = 0;
//    [UIView setAnimationDidStopSelector:@selector(removeOverlay)];
//    [UIView commitAnimations];
    pinCodeViewController=nil;
}

-(void) pinCodeViewLogout {
    NSLog(@"logging out");
//    [self.currentUser setPinCode:NULL];
//    [self logout:self];
}

//- (void)removeOverlay {
//    if (pinCodeViewController == nil) {
//        [darkOverlay removeFromSuperview];
//        [darkOverlay release];
//        darkOverlay = nil;
//    }
//}

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
	
	// get image and close signature controller
	
	// I replaced the view just to show it works...
	UIImageView *imageview = [[UIImageView alloc] initWithImage:signatureImage];
	[imageview setContentMode:UIViewContentModeCenter];
	[imageview sizeToFit];
	[imageview setTransform:sender.view.transform];
	sender.view = imageview;
    [self performSelector:@selector(dismissJBView) withObject:nil afterDelay:2.0];
//	
//	// Example saving the image in the app's application support directory
//	NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
//	[UIImagePNGRepresentation(signatureImage) writeToFile:[appSupportPath stringByAppendingPathComponent:@"signature.png"] atomically:YES];
	
	
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
    
//    // Attach an image to the email
//    NSData *myData = [NSData dataWithContentsOfURL:recorder.url];
//    [picker addAttachmentData:myData mimeType:@"audio/mp4a-latm" fileName:@"recording.m4a"];
    
    // Fill out the email body text
    [mailVC setMessageBody:@"Please find attached a CSV file of signer information and a zip file of collected signatures for petition X." isHTML:NO];
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

@end
