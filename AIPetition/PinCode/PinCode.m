//
//  PinCode.m
//  PinCode
//
//  Created by Oriol Vilaró on 20/06/11.
//  Copyright 2011 Bazinga Systems. All rights reserved.
//

#import "PinCode.h"


@implementation PinCode

@synthesize delegate;

@synthesize firstElementTextField;
@synthesize fourthElementTextField;
@synthesize oneButton;
@synthesize twoButton;
@synthesize threeButton;
@synthesize fourButton;
@synthesize fiveButton;
@synthesize sixButton;
@synthesize sevenButton;
@synthesize eightButton;
@synthesize nineButton;
@synthesize zeroButton;
@synthesize deleteButton;
@synthesize titleLabel;
@synthesize cancelButton;
@synthesize logoutButton;
@synthesize descriptionLabel;
@synthesize failedAttemptLabel;
@synthesize secondElementTextField;
@synthesize thirdElementTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        inputCode=[[NSMutableString alloc] initWithCapacity:4];
        [inputCode setString:@""];
    }
    return self;
}

- (void)dealloc
{
    [inputCode release];
    
    [firstElementTextField release];
    [fourthElementTextField release];
    [secondElementTextField release];
    [thirdElementTextField release];
    [titleLabel release];
    [cancelButton release];
    [descriptionLabel release];
    [oneButton release];
    [twoButton release];
    [threeButton release];
    [fourButton release];
    [fiveButton release];
    [sixButton release];
    [sevenButton release];
    [nineButton release];
    [eightButton release];
    [zeroButton release];
    [deleteButton release];
    [failedAttemptLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setFirstElementTextField:nil];
    [self setFourthElementTextField:nil];
    [self setSecondElementTextField:nil];
    [self setThirdElementTextField:nil];
    [self setTitleLabel:nil];
    [self setCancelButton:nil];
    [self setDescriptionLabel:nil];
    [self setOneButton:nil];
    [self setTwoButton:nil];
    [self setThreeButton:nil];
    [self setFourButton:nil];
    [self setFiveButton:nil];
    [self setSixButton:nil];
    [self setSevenButton:nil];
    [self setNineButton:nil];
    [self setEightButton:nil];
    [self setZeroButton:nil];
    [self setDeleteButton:nil];
    [self setFailedAttemptLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (IBAction)buttonPressedAction:(id)sender {
    
    [self.failedAttemptLabel setHidden:YES];

    
    switch ([sender tag]) {
            
        case 200: // delete button
            if ([inputCode length]>0) {
                
                // change textfields
                switch ([inputCode length]) {
                    case 1:
                        firstElementTextField.text=@"";
                        break;
                    case 2:
                        secondElementTextField.text=@"";
                        break;
                    case 3:
                        thirdElementTextField.text=@"";
                        break;
                    case 4:
                        fourthElementTextField.text=@"";
                        break;
                    default:
                        break;
                }

                // delete last input
                [inputCode deleteCharactersInRange:NSMakeRange([inputCode length]-1, 1)];
            }
            break;
            
        case 300: // cancel button
            
            [self.view removeFromSuperview];
            [delegate pinCodeViewWillClose];
            
            break;
            
        case 400: // logout button
            [delegate pinCodeViewLogout];
            break;
            
        default: // number buttons
            [inputCode appendString:[NSString stringWithFormat:@"%d",[sender tag]-100]];
            
            // change textfields
            switch ([inputCode length]) {
                case 1:
                    firstElementTextField.text=@"*";
                    break;
                case 2:
                    secondElementTextField.text=@"*";
                    break;
                case 3:
                    thirdElementTextField.text=@"*";
                    break;
                case 4:
                    fourthElementTextField.text=@"*";
                    break;
                default:
                    break;
            }
            
            if ([inputCode length]==4) {
                
                // Check the PinCode later to update the 4th textfield 
                [self performSelector:@selector(checkPinCode) withObject:nil afterDelay:0.2];
            }
            break;
    }    
}

-(void)checkPinCode{
    // check code
    if ([delegate isPinCodeCorrect:inputCode]){
        
        [self.view removeFromSuperview];
        [delegate pinCodeViewWillClose];
        
    }else{ // bad code
        
        // resetting
        [inputCode setString:@""];
        firstElementTextField.text=@"";
        secondElementTextField.text=@"";
        thirdElementTextField.text=@"";
        fourthElementTextField.text=@"";
        logoutButton.hidden = NO;
        failedAttemptLabel.hidden = NO;
        [self earthquake:self.view];
    }
}

- (void)earthquake:(UIView*)itemView
{
    CGFloat t = 4.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:itemView];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.06];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if ([finished boolValue]) 
    {
        UIView* item = (UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

@end