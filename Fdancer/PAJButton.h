//
//  PAJButton.h
//  Fdancer
//
//  Created by peder jonsson on 03/06/14.
//  Copyright (c) 2014 Peder_jonsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PAJButtonListenerProtocol <NSObject>
    @required
- (void)didTapButton:(UIView *) button correctAnswer:(BOOL) isCorrectAnswer;
@end

@interface PAJButton : UIView
{
    float lastClickedX;
    UIView *topView;
    UIView *circle;
    UIColor *activeColor;
    UIColor *passiveColor;
    UIColor *circleColor;
    bool correctAnswer;
    int size;
}

@property (nonatomic, weak) id<PAJButtonListenerProtocol> delegate;
-(void) reset: (bool) isCorrectAnswer;
-(void) upAnimation;
-(void) downAnimation;

@end
