//
//  IdeaDetailViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaDetailViewController.h"

#import "Utils/IdeaManager.h"
#import "Utils/UserManager.h"
#import "Models/Idea.h"

#import "DejalActivityView.h"
#import "Utils/ServerAPI.h"

#import "NZAlertView/NZAlertView.h"

#import "GeoLocationManager.h"

@interface IdeaDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numDislikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation IdeaDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_idea) {
        _ideaContent.text = _idea.content;
        _numDislikesLabel.text = [NSString stringWithFormat:@"%i", [_idea.dislikes intValue]];
        _numLikesLabel.text = [NSString stringWithFormat:@"%i", [_idea.likes intValue]];
        
        if([_idea.shared boolValue]) {
            float dist = [[GeoLocationManager sharedInstance] distanceFromCurrentLocation:[_idea.latitude floatValue]
                                                                                longitude:[_idea.longitude floatValue]];
            if(dist > 0) {
                _distanceLabel.text = [NSString stringWithFormat:@"%.2f", dist];
            } else {
                _distanceLabel.text = @"unknown";
            }
        } else
            _distanceLabel.text = @"not shared";
    }
    
    [_ideaContent becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)activityButtonClicked:(id)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[_idea.content] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)deleteButtonClicked:(id)sender {
    [[IdeaManager sharedInstance] removeIdea:_idea withNotification:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlert:(NSString*)title message:(NSString*)message style:(NSInteger)style {
    NZAlertView *alert = [[NZAlertView alloc] initWithStyle:style
                                                      title:title
                                                    message:message
                                                   delegate:nil];
    
    [alert setAlertDuration:1.5f];
    [alert setBlurParameter:0.1f];
    [alert setTextAlignment:NSTextAlignmentCenter];
    
    [alert show];
}

- (IBAction)shareButtonClicked:(id)sender {
    CLLocation* lastLoc = [[GeoLocationManager sharedInstance] lastLocation];
    _idea.latitude = [NSNumber numberWithDouble:lastLoc.coordinate.latitude];
    _idea.longitude = [NSNumber numberWithDouble:lastLoc.coordinate.longitude];
    
    if(![_idea.shared boolValue]) {
        [DejalBezelActivityView activityViewForView:self.view];
    
        [ServerAPI shareIdea:_idea user:[UserManager getCurrentUser] success:^(NSString* uuid) {
            [DejalActivityView removeView];
            
            [[IdeaManager sharedInstance] ideaChanged:_idea withNotification:YES];
            
            [self showAlert:@"Info" message:@"Idea shared" style:NZAlertStyleSuccess];
        } fail:^{
            [DejalActivityView removeView];
            
            [self showAlert:@"Info" message:@"Share idea failed" style:NZAlertStyleError];
        }];
        
    } else {
        
        [self showAlert:@"Info" message:@"Idea already shared" style:NZAlertStyleInfo];
    }
}

@end
