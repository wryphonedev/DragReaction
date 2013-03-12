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
    
    NSArray *viewsOfInterest = @[self.oneView, self.twoView, self.threeView];
    [self setEvaluateViews:viewsOfInterest];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (IBAction)handlePanRecognizer:(id)sender
{
    UIPanGestureRecognizer *recongizer = (UIPanGestureRecognizer *)sender;
    
    if ([recongizer state] == UIGestureRecognizerStateBegan)
    {
        [[self completionLabel] setText:nil];
    }

    NSArray *views = [self evaluateViews];
    __block UILabel *label = [self completionLabel];
    
    [recongizer dragWhileEvaluatingOverlappingViews:views
                                      overlapsBlock:^(UIView *overlapView) {
                                          
                                          [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                              
                                              UIView *aView = (UIView *)obj;
                                              
                                              // Style an overlapping view
                                              if (aView == overlapView)
                                              {
                                                  aView.layer.borderWidth = 8.0f;
                                                  aView.layer.borderColor = [[UIColor redColor] CGColor];
                                              }
                                              // Remove styling on non-overlapping views
                                              else
                                              {
                                                  aView.layer.borderWidth = 0.0f;
                                              }
                                              
                                          }];

                                      } completion:^(UIView *overlapView) {
                                          
                                          if (overlapView)
                                          {
                                              NSUInteger overlapIndex = [[self evaluateViews] indexOfObject:overlapView];
                                              NSString *completionText = [NSString stringWithFormat:@"Released over view at index: %d", overlapIndex];
                                              [label setText:completionText];
                                          }
                                          
                                          // Remove styling from all views
                                          [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                              UIView *aView = (UIView *)obj;
                                              aView.layer.borderWidth = 0.0f;
                                          }];
                                      }];

}

@end
