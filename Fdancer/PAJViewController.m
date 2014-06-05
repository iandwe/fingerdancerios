//
//  PAJViewController.m
//  Fdancer
//
//  Created by peder jonsson on 03/06/14.
//  Copyright (c) 2014 Peder_jonsson. All rights reserved.
//

#import "PAJViewController.h"
#import "PAJButton.h"
#import "PAJSettings.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface PAJViewController ()

@end

@implementation PAJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initiateStuff];
    [self setUpBoardAndButtons];
}

-(void)initiateStuff
{
    
    
    
    currentBoardInRound = 0;
    pointsForSimultaneousClick = 0;
    totalPointsForRound = 0;
    simultaneousPushIsOpen = false;
    receivedPushFromThisRound = false;
    madeError = false;
    arrayWithBasicNumbers = [[NSMutableArray alloc] init];
    btnArray = [[NSMutableArray alloc] init];
    
    
    
}


-(void)didTapButton:(UIView *)button correctAnswer:(BOOL)isCorrectAnswer
{
    if(!receivedPushFromThisRound)
    {
        simultaneousPushIsOpen = true;
        [self startTimerForSimultaneousBlock];
    }
    receivedPushFromThisRound = true;
    if(simultaneousPushIsOpen)
    {
        if(isCorrectAnswer && !madeError)
        {
            pointsForSimultaneousClick ++;
            //playsound
             //NSLog(@"correct: %li",(long)[button tag]);
        }
        else
        {
            madeError = true;
            pointsForSimultaneousClick = 0;
            //playsound
             //NSLog(@"made error so thisclick not good anyway: %li",(long)[button tag]);
        }
    }
    else
    {
        NSLog(@"pushsimul is not open");
    }
}



-(void)setPointsTotal
{
    [totalPointsDisplay setText:[NSString stringWithFormat:@"%i",totalPointsForRound]];
}

-(void)setPointsForClicks: (int) value
{
    totalPointsForRound += value;
    NSLog(@"nu sätter green points: %i",value);
    [clickPointsDisplay setText:[NSString stringWithFormat:@"%i",value]];
}

-(void)emptyClickPoints
{
    [clickPointsDisplay setText:@""];
}

-(void)startTimerForSimultaneousBlock
{
    
    
    [NSTimer scheduledTimerWithTimeInterval:SIMULTANEOUS_PUSH_FORGIVENESSTIME
                                     target:self
                                   selector:@selector(executeWhenSImultaneousBlockTimerIsOver)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)executeWhenSImultaneousBlockTimerIsOver
{
    simultaneousPushIsOpen = false;
    [self setPointsForClicks:pointsForSimultaneousClick];
    pointsForSimultaneousClick = 0;
    
}

-(void)startRound
{
    [self setPointsTotal];
    [NSTimer scheduledTimerWithTimeInterval:ROUND_TIME
                                                     target:self
                                                   selector:@selector(reset)
                                                   userInfo:nil
                                                    repeats:NO];
   
}


-(void)setUpBoardAndButtons
{
    int margin = 10;
    if (IPAD) {
        // TODO
        //Need more margin / smaller squares for ipad
    }
    int height = self.view.frame.size.height;
    int width = self.view.frame.size.width;
    int squaresize = (width / 3) - (margin);
    int startingXPos = ((width - (squaresize * 3)) / 2)-margin;
    int xpos = startingXPos;
    int ypos = (height / 2) - ((squaresize*3)+margin)/2;
    
    totalPointsDisplay = [[UILabel alloc] initWithFrame:CGRectMake(width/2, ypos/3, 50, 70)];
    // lbl.text = @"New";
    totalPointsDisplay.backgroundColor = [UIColor clearColor];
    totalPointsDisplay.textColor = [UIColor blackColor];
    totalPointsDisplay.highlightedTextColor = [UIColor blackColor];
    totalPointsDisplay.font = [UIFont systemFontOfSize:24];
    totalPointsDisplay.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:totalPointsDisplay];
    
    clickPointsDisplay = [[UILabel alloc] initWithFrame:CGRectMake((width/2)-70, ypos/3, 50, 70)];
    // lbl.text = @"New";
    clickPointsDisplay.backgroundColor = [UIColor clearColor];
    clickPointsDisplay.textColor = [UIColor greenColor];
    clickPointsDisplay.highlightedTextColor = [UIColor blackColor];
    clickPointsDisplay.font = [UIFont systemFontOfSize:34];
    clickPointsDisplay.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:clickPointsDisplay];
    
    for(int i = 0; i < 9; i++)
    {
        NSNumber *num = [NSNumber numberWithInt:i];
        [arrayWithBasicNumbers addObject:num];
        if(i == 3 || i == 6)
        {
            ypos += squaresize + margin;
            xpos = startingXPos;
        }
       
        PAJButton *btn = [[PAJButton alloc] initWithFrame:CGRectMake(xpos,ypos,squaresize,squaresize)];
        [self.view addSubview:btn];
        btn.delegate = self;
        [btn setTag:i];
        [btnArray addObject:btn];
        xpos += (squaresize + margin);
    }
    
    [self reset];
}

-(void)reset
{
    currentBoardInRound ++;
    [self emptyClickPoints];
    receivedPushFromThisRound = false;
    madeError = false;
    NSMutableArray *randomNumbers = [self getArrayWithRandomNumbers:AMOUNT_HIGHLIGHTED_BUTTONS];
    for(int i = 0; i < btnArray.count; i++)
    {
        bool foundMatch = false;
        for(int j = 0; j < randomNumbers.count; j++)
        {
            NSNumber *num = [NSNumber numberWithInteger:i];
            if([[randomNumbers objectAtIndex:j] isEqualToNumber: num])
            {
                foundMatch = true;
                [[btnArray objectAtIndex:i] reset:true];
                break;
            }
        }
        if(!foundMatch)
        {
            [[btnArray objectAtIndex:i] reset:false];
        }
    }
    if(currentBoardInRound == LEVEL_ONE_SIZE)
    {
        //showResultForFinishedLevel("");
        NSLog(@"game over");
    }
    else
    {
        [self startRound];
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeRight;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //UIInterfaceOrientation *face = UIInterfaceOrientationLandscapeRight;
    return UIInterfaceOrientationLandscapeRight;
}

-(void)shuffleArray
{
    
    for (int x = 0; x < [arrayWithBasicNumbers count]; x++) {
        int randInt = (arc4random() % ([arrayWithBasicNumbers count] - x)) + x;
        [arrayWithBasicNumbers exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
}

-(NSMutableArray *)getArrayWithRandomNumbers:(int)amountNumbersNeeded
{
    [self shuffleArray];
    NSMutableArray *arrayWithRandomNumbers = [[NSMutableArray alloc] init];
    for(int i = 0; i < amountNumbersNeeded; i++)
    {
        NSNumber *randomInt = [arrayWithBasicNumbers objectAtIndex:i];
        [arrayWithRandomNumbers addObject:randomInt];
    }
    return arrayWithRandomNumbers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
