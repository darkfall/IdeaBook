//
//  ResizeModelViewSegue.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "ModalViewSegue.h"


@implementation ModalViewSegue

- (void)perform {
    id sourceController = self.sourceViewController;
    id destinationController = self.destinationViewController;
  
    [destinationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [destinationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [sourceController presentViewController:destinationController animated:YES completion:nil];
    
}


@end
