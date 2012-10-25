//
//  ZSViewController.m
//  DragReaction
//
//  Created by Isaac Schmidt on 10/25/12.
//  Copyright (c) 2012 Zuse. All rights reserved.
//

#import "ZSViewController.h"
#import "UIPanGestureRecognizer+ZSDraggingAdditions.h"

@interface ZSViewController ()

@property (strong, nonatomic) NSArray *evaluateViews;

@end

@implementation ZSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // We add the views we wish to evaluate to an array...
    NSArray *viewsOfInterest = @[self.oneView, self.twoView, self.threeView];
    [self setEvaluateViews:viewsOfInterest];
    
}

- (IBAction)handlePanRecognizer:(id)sender
{
    UIPanGestureRecognizer *recongizer = (UIPanGestureRecognizer *)sender;

    NSArray *views = [self evaluateViews];
    
    [recongizer dragWithinView:self.view
      evaluateOverlappingViews:views
                 overlapsBlock:^(UIView *overlapView) {
                     
                     [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         
                         UIView *aView = (UIView *)obj;
                         
                          // Style an overlapping view
                         if (aView == overlapView)
                         {
                             aView.layer.borderWidth = 8.0f;
                             aView.layer.borderColor = [[UIColor redColor] CGColor];
                         }
                          // Remove style or handle non-overlapping views
                         else
                         {
                             aView.layer.borderWidth = 0.0f;
                         }
                         
                     }];
                     
                 }
                    completion:nil];
    
}

@end
