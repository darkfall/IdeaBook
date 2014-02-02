//
//  AddCommentViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "AddCommentViewController.h"

#import "Utils/ServerAPI.h"
#import "Utils/AlertHelper.h"

#import "Models/Idea.h"

#import "NZAlertView.h"
#import "DejalActivityView.h"

@interface AddCommentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentText;

@end

@implementation AddCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [_contentText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)doneClicked:(id)sender {
    if(_contentText.text.length == 0) {
        [AlertHelper showNZAlert:@"Info" message:@"Comment content cannot be empty" style:NZAlertStyleInfo];
    } else {
        
        [DejalBezelActivityView activityViewForView:self.view];
        
        [ServerAPI addComment:_idea comment:_contentText.text success:^(NSString* uuid) {
        
            [DejalBezelActivityView removeView];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } fail:^{
            [AlertHelper showNZAlert:@"Error" message:@"Unable to add comment, please try again later" style:NZAlertStyleInfo];
            [DejalBezelActivityView removeViewAnimated:YES];
        }];
    }
}

@end
