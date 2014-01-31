//
//  SecondViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaNearbyViewController.h"
#import "SWRevealViewController/SWRevealViewController.h"

@interface IdeaNearbyViewController ()

@end

@implementation IdeaNearbyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

@end
