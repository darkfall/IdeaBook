//
//  SettingsViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController/SWRevealViewController.h"

#import "Utils/UserManager.h"
#import "Utils/GeoLocationManager.h"

#import "Models/IdeaUser.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *locationServiceSwitch;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [_userNameLabel setReturnKeyType:UIReturnKeyDone];
    _userNameLabel.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    _userNameLabel.text = [UserManager getCurrentUser].name;
    _locationServiceSwitch.on = [UserManager getEnableLocationService];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UserManager getCurrentUser].name = _userNameLabel.text;
    [UserManager saveCurrentUser];
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)enableLocationServiceChanged:(id)sender {
    [UserManager setEnableLocationService:_locationServiceSwitch.on];
    if(_locationServiceSwitch.on) {
        [[GeoLocationManager sharedInstance] startUpdate];
    } else {
        [[GeoLocationManager sharedInstance] stopUpdate];
    }
}

- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

@end
