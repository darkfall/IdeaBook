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
@property (strong, nonatomic) NSString* ideaContent;

@end

@implementation NewIdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ideaContentTextView.delegate = self;
    [_ideaContentTextView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    _ideaContentTextView.text = _ideaContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)setIdeaContent:(NSString*)content {
    _ideaContentTextView.text = content;
    _ideaContent = content;
}

- (IBAction)doneClicked:(id)sender {
    [[IdeaManager sharedInstance] addIdea:_ideaContentTextView.text title:@"New Idea" withNotification:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
