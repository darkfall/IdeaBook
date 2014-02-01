//
//  IdeaDetailViewController.h
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Idea;

@interface IdeaDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *ideaContent;

@property (weak, nonatomic) Idea* idea;

@end
