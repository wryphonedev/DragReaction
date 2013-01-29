//
//  UIPanGestureRecognizer+ZSDraggingAdditions.h
//  DragReaction
//
//  Created by Isaac Schmidt on 10/25/12.
//  Copyright (c) 2012 Zuse. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIPanGestureRecognizer (ZSDraggingAdditions)

@property (assign) CGPoint startPoint;

- (void)dragWithinView:(UIView *)view evaluateOverlappingViews:(NSArray *)views overlapsBlock:(void (^)(UIView *overlapView))overlapsBlock completion:(void (^)(UIView *overlapView))completionBlock;

@end
