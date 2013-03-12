//
//  ZSViewController.h
//  DragReaction
//
//  Created by Isaac Schmidt on 10/25/12.
//  Copyright (c) 2012 Zuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *draggingView;
@property (nonatomic, weak) IBOutlet UIView *oneView;
@property (nonatomic, weak) IBOutlet UIView *twoView;
@property (nonatomic, weak) IBOutlet UIView *threeView;
@property (nonatomic, weak) IBOutlet UILabel *completionLabel;
@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *panRecognizer;

- (IBAction)handlePanRecognizer:(id)sender;

@end
