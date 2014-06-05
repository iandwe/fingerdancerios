//
//  PAJButton.m
//  Fdancer
//
//  Created by peder jonsson on 03/06/14.
//  Copyright (c) 2014 Peder_jonsson. All rights reserved.
//

#import "PAJButton.h"

@implementation PAJButton

- (id)initWithFrame:(CGRect)frame
{
    
    activeColor = [UIColor colorWithRed:1 green:0.541 blue:0.961 alpha:1]; /*#ff8af5*/
    passiveColor = [UIColor colorWithRed:0.314 green:0.89 blue:0.761 alpha:1]; /*#50e3c2*/
    
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        int size = self.frame.size.width;
        CGRect rectForTopView = CGRectMake(0, 0, size, size);
        topView = [[UIView alloc] initWithFrame:rectForTopView];
        
        [self addSubview:topView];
        
        //The setup code (in viewDidLoad in your view controller)
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}




- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  
    [self.delegate didTapButton:self correctAnswer:correctAnswer];
}

-(void)reset:(bool)isCorrectAnswer
{
    correctAnswer = isCorrectAnswer;
    if(isCorrectAnswer)
    {
        topView.backgroundColor = activeColor;
        [self upAnimation];
    }
    else
    {
        topView.backgroundColor = passiveColor;
        [self downAnimation];
    }
}

-(void)upAnimation
{
    CGRect newTopFrame = topView.frame;
    newTopFrame.origin.y = 4;
    newTopFrame.origin.x = 4;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    //[UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    topView.frame = newTopFrame;
    [UIView commitAnimations];
}

-(void)downAnimation
{
    CGRect newTopFrame = topView.frame;
    newTopFrame.origin.y = 1;
    newTopFrame.origin.x = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
   // [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    topView.frame = newTopFrame;
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
