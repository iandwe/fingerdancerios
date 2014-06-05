//
//  PAJViewController.h
//  Fdancer
//
//  Created by peder jonsson on 03/06/14.
//  Copyright (c) 2014 Peder_jonsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAJButton.h"



@interface PAJViewController : UIViewController <PAJButtonListenerProtocol>
{
    NSMutableArray *btnArray;
    NSMutableArray *arrayWithBasicNumbers;
    bool simultaneousPushIsOpen;
    bool receivedPushFromThisRound;
    bool madeError;
    int pointsForSimultaneousClick;
    int totalPointsForRound;
    int currentBoardInRound;
    NSTimer *timerForSimultaneousPush;
    UILabel *totalPointsDisplay;
    UILabel *clickPointsDisplay;
    
}
-(void)startTimerForSimultaneousBlock;



@end
