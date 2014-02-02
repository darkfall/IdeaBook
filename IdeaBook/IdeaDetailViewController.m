//
//  IdeaDetailViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaDetailViewController.h"

#import "Models/Idea.h"
#import "DejalActivityView.h"

#import "Utils/IdeaManager.h"
#import "Utils/GeoLocationManager.h"

#import "Utils/ServerAPI.h"

@interface IdeaDetailViewController () {
    bool _contentChanged;
}

@property (weak, nonatomic) IBOutlet UILabel *numDislikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

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
        
        
        [self updateDistance];
        if([_idea.shared boolValue]) {
            _shareButton.imageView.image = [UIImage imageNamed:@"brightness_light"];
            
        } else {
            _shareButton.imageView.image = [UIImage imageNamed:@"brightness"];
        }
    }
    
    _ideaContent.delegate = self;
    _contentChanged = false;
    
    [_ideaContent becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textViewDidChange:(UITextView *)textView {
    _contentChanged = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    if(_contentChanged) {
        _idea.content = _ideaContent.text;
        [[IdeaManager sharedInstance] ideaChanged:_idea withNotification:YES];
    }
}

- (void)updateDistance {
    if([_idea.shared boolValue]) {
        float dist = [[GeoLocationManager sharedInstance] distanceFromCurrentLocation:[_idea.latitude floatValue]
                                                                            longitude:[_idea.longitude floatValue]];
        if(dist > 0) {
            _distanceLabel.text = [NSString stringWithFormat:@"%.2fmi away", dist];
        } else {
            _distanceLabel.text = @"unknown mi away";
        }
    } else {
        _distanceLabel.text = @"not shared";
    }
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

- (IBAction)shareButtonClicked:(id)sender {
    CLLocation* lastLoc = [[GeoLocationManager sharedInstance] lastLocation];
    if(lastLoc) {
        _idea.latitude = [NSNumber numberWithDouble:lastLoc.coordinate.latitude];
        _idea.longitude = [NSNumber numberWithDouble:lastLoc.coordinate.longitude];
    } else {
        _idea.latitude = [NSNumber numberWithDouble:0];
        _idea.longitude = [NSNumber numberWithDouble:0];
    }
    
    [[IdeaManager sharedInstance] shareOrCancelShareIdea:_idea onView:self.view withNotification:YES onShared:^{
        
        _shareButton.imageView.image = [UIImage imageNamed:@"brightness_light"];
        [self updateDistance];
        
    } onCancelled:^{
        
        _shareButton.imageView.image = [UIImage imageNamed:@"brightness"];
        [self updateDistance];
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
