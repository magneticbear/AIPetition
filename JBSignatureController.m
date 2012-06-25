//
//  JBSignatureController.m
//  JBSignatureController
//
//  Created by Jesse Bunch on 12/10/11.
//  Copyright (c) 2011 Jesse Bunch. All rights reserved.
//

#import "JBSignatureController.h"
#import "JBSignatureView.h"

#pragma mark - *** Private Interface ***

@interface JBSignatureController() {
@private
	__strong JBSignatureView *signatureView_;
	__strong UIImageView *signaturePanelBackgroundImageView_;
	__strong UIImage *portraitBackgroundImage_, *landscapeBackgroundImage_;
	__strong UIButton *confirmButton_, *cancelButton_;
	__weak id<JBSignatureControllerDelegate> delegate_;
}

// The view responsible for handling signature sketching
@property(nonatomic,strong) JBSignatureView *signatureView;

// The background image underneathe the sketch
@property(nonatomic,strong) UIImageView *signaturePanelBackgroundImageView;

// Private Methods
-(void)didTapConfirmButton;
-(void)didTapCancelButton;

@end

@implementation JBSignatureController

@synthesize
signaturePanelBackgroundImageView = signaturePanelBackgroundImageView_,
signatureView = signatureView_,
portraitBackgroundImage = portraitBackgroundImage_,
landscapeBackgroundImage = landscapeBackgroundImage_,
confirmButton = confirmButton_,
cancelButton = cancelButton_,
delegate = delegate_,
firstNameField = _firstNameField,
lastNameField = _lastNameField,
emailAddressField = _emailAddressField;

#pragma mark - *** Initializers ***

/**
 * Designated initializer
 * @author Jesse Bunch
 **/
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	}
	
	return self;
	
}

/**
 * Initializer
 * @author Jesse Bunch
 **/
-(id)init {
	return [self initWithNibName:nil bundle:nil];
}




#pragma mark - *** View Lifecycle ***

/**
 * Since we're not using a nib. We need to load our views manually.
 * @author Jesse Bunch
 **/
-(void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	// Background images
	self.portraitBackgroundImage = [UIImage imageNamed:@"bg-signature-portrait"];
	self.landscapeBackgroundImage = [UIImage imageNamed:@"bg-signature-landscape"];
	self.signaturePanelBackgroundImageView = [[UIImageView alloc] initWithImage:self.portraitBackgroundImage];
	
	// Signature view
	self.signatureView = [[JBSignatureView alloc] init];
	
	// Confirm
	self.confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
	[self.confirmButton sizeToFit];
	[self.confirmButton setFrame:CGRectMake(self.view.frame.size.width - self.confirmButton.frame.size.width - 10.0f, 
											10.0f, 
											self.confirmButton.frame.size.width, 
											self.confirmButton.frame.size.height)];
	[self.confirmButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	
	// Cancel
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[self.cancelButton sizeToFit];
	[self.cancelButton setFrame:CGRectMake(10.0f, 
										   10.0f, 
										   self.cancelButton.frame.size.width, 
										   self.cancelButton.frame.size.height)];
	[self.cancelButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    
    // AI specfic fields
    _firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, (cancelButton_.frame.origin.y + cancelButton_.frame.size.height) + 20, self.view.frame.size.width / 2, 35.0f)];
    _firstNameField.placeholder = @"First Name";
    [_firstNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_firstNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [_firstNameField setFont:[UIFont systemFontOfSize:18.0]];
    [_firstNameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_firstNameField setReturnKeyType:UIReturnKeyNext];
    _firstNameField.delegate = self;

    _lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, (_firstNameField.frame.origin.y + _firstNameField.frame.size.height) + 10, self.view.frame.size.width / 2, 35.0f)];
    _lastNameField.placeholder = @"Last Name";
    [_lastNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_lastNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [_lastNameField setFont:[UIFont systemFontOfSize:18.0]];
    [_lastNameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_lastNameField setReturnKeyType:UIReturnKeyNext];
    _lastNameField.delegate = self;
    
    _emailAddressField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, (_lastNameField.frame.origin.y + _lastNameField.frame.size.height) + 10, self.view.frame.size.width / 2, 35.0f)];
    _emailAddressField.placeholder = @"Email Address";
    [_emailAddressField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_emailAddressField setBorderStyle:UITextBorderStyleRoundedRect];
    [_emailAddressField setTextColor:[UIColor blueColor]];
    [_emailAddressField setFont:[UIFont systemFontOfSize:18.0]];
    [_emailAddressField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_emailAddressField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_emailAddressField setKeyboardType:UIKeyboardTypeEmailAddress];
    [_emailAddressField setReturnKeyType:UIReturnKeyGo];
    _emailAddressField.delegate = self;
    
    [_firstNameField becomeFirstResponder];
}

/**
 * Setup the view heirarchy
 * @author Jesse Bunch
 **/
-(void)viewDidLoad {
	
	// Background Image
	[self.signaturePanelBackgroundImageView setFrame:self.view.bounds];
	[self.signaturePanelBackgroundImageView setContentMode:UIViewContentModeTopLeft];
	[self.view addSubview:self.signaturePanelBackgroundImageView];
	
	// Signature View
	[self.signatureView setFrame:self.view.bounds];
	[self.view addSubview:self.signatureView];
	
	// Buttons
	[self.view addSubview:self.cancelButton];
	[self.view addSubview:self.confirmButton];
	
	// Button actions
	[self.confirmButton addTarget:self action:@selector(didTapConfirmButton) forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    
    // AI specfic fields
    [self.view addSubview:_firstNameField];
    [self.view addSubview:_lastNameField];
    [self.view addSubview:_emailAddressField];
    
	
}

/**
 * Support for different orientations
 * @author Jesse Bunch
 **/
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 	
	return YES;
}

/**
 * Upon rotation, switch out the background image
 * @author Jesse Bunch
 **/
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[self.signaturePanelBackgroundImageView setImage:self.landscapeBackgroundImage];
	} else {
		[self.signaturePanelBackgroundImageView setImage:self.portraitBackgroundImage];
	}
	
}

/**
 * After rotation, we need to adjust the signature view's frame to fill.
 * @author Jesse Bunch
 **/
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.signatureView setFrame:self.view.bounds];
	[self.signatureView setNeedsDisplay];
}


#pragma mark - *** Actions ***

/**
 * Upon confirmation, message the delegate with the image of the signature.
 * @author Jesse Bunch
 **/
-(void)didTapConfirmButton {
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureConfirmed:signatureController:)]) {
		UIImage *signatureImage = [self.signatureView getSignatureImage];
		[self.delegate signatureConfirmed:signatureImage signatureController:self];
	}
}

/**
 * Upon cancellation, message the delegate.
 * @author Jesse Bunch
 **/
-(void)didTapCancelButton {
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureCancelled:)]) {
        [self.delegate signatureCancelled:self];
	}
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - *** Public Methods ***

/**
 * Clears the signature from the signature view. If the delegate is subscribed,
 * this method also messages the delegate with the image before it's cleared.
 * @author Jesse Bunch
 **/
-(void)clearSignature {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureCleared:signatureController:)]) {
		UIImage *signatureImage = [self.signatureView getSignatureImage];
		[self.delegate signatureCleared:signatureImage signatureController:self];
	}
	
	[self.signatureView clearSignature];
}

#pragma mark - textFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField ==_firstNameField){
        [_lastNameField becomeFirstResponder];
    } else if(textField == _lastNameField){
        [_emailAddressField becomeFirstResponder];
    } else if(textField == _emailAddressField) {
        [_emailAddressField resignFirstResponder];
    }
    return YES;
}

@end
