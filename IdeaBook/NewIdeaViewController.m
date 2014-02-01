//
//  NewIdeaViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "NewIdeaViewController.h"
#import "Utils/IdeaManager.h"

@interface NewIdeaViewController ()

@property (weak, nonatomic) IBOutlet UITextView *ideaContentTextView;

@end

@implementation NewIdeaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ideaContentTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)textViewDidBeginEditing:(UITextView *)textView1 {
    CGRect textViewFrame = CGRectMake(0, 63, 320, 417 - 216);
    _ideaContentTextView.frame = textViewFrame;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGRect textViewFrame = CGRectMake(0, 63, 320, 417);
    _ideaContentTextView.frame = textViewFrame;
    [_ideaContentTextView endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)doneClicked:(id)sender {
    [[IdeaManager sharedInstance] addIdea:_ideaContentTextView.text title:@"New Idea"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
