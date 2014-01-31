//
//  ResizeModelViewSegue.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "ResizeModelViewSegue.h"

@implementation ResizeModelViewSegue

- (void)perform
{
    id sourceController = self.sourceViewController;
    id destinationController = self.destinationViewController;
    UIView *destinationView = [destinationController view];
    CGFloat x, y, w, h;
    
    [destinationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [destinationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [sourceController presentViewController:destinationController animated:YES completion:nil];
    
    /*
     You have to present the view first, and then resize it. That's because,
     as far as I can tell, when you present your view modally, a new view is created
     that covers the screen in a black semi-transparent mask to give the shadow effect,
     and a container view is placed in the middle of this view that in turn holds the
     view you are presenting. Your view automatically resizes to the size of this
     container view, so that's the view you need to resize to make your view controller
     appear the size you desire. You must present your modal view first
     because until you do, the container view doesn't exist. The following code
     resizes the container view (which is now your modal view's superview) and then
     resets the position of the container view to the center of the source view that
     is presenting the modal view so everything looks nice and centered.
     */
    x = destinationView.superview.frame.origin.x;
    y = destinationView.superview.frame.origin.y;
    w = 200;  // Your desired modal view width
    h = 200;  // Your desired modal view height
    destinationView.superview.frame = CGRectMake(x, y, w, h);
    destinationView.superview.center = [[sourceController view] center];
}


@end
