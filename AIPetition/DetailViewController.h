//
//  DetailViewController.h
//  AIPetition
//
//  Created by Jean-Pierre Simard on 12-06-07.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinCode.h"
#import "JBSignatureController.h"
#import <MessageUI/MessageUI.h>
#import "User.h"
#import "AppDelegate.h"
#import "Signer.h"

@interface DetailViewController : UIViewController <PinCodeDelegate,UISplitViewControllerDelegate,JBSignatureControllerDelegate,MFMailComposeViewControllerDelegate> {
    PinCode *pinCodeViewController;
    UIView *darkOverlay;
    User *currentUser;
    AppDelegate *appDel;
}

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIWebView *petitionView;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) User *currentUser;

@property (strong, nonatomic) UIBarButtonItem *lockBtn;

- (IBAction)sign:(id)sender;

@end
