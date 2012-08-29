//
//  RPNCalculatorViewController.m
//  RPNCalculator
//
//  Created by Kyle Maher on 8/26/12.
//  Copyright (c) 2012 Kyle Maher. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "RPNCalculatorEngine.h"

@interface RPNCalculatorViewController ()

@property (nonatomic) BOOL userIsEnteringNumbers;
@property (nonatomic, strong) RPNCalculatorEngine *engine;

@end


@implementation RPNCalculatorViewController

@synthesize engine = _engine;
@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsEnteringNumbers = _userIsEnteringNumbers;


- (RPNCalculatorEngine *)engine
{
    if (!_engine)
        _engine = [[RPNCalculatorEngine alloc] init];
    
    return _engine;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setHistory:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)updateHistory
{
    self.history.text = [[RPNCalculatorEngine descriptionOfProgram:self.engine.program] stringByAppendingString:@" ="];
}


- (void)displayMayNotReflectResult
{
    NSRange location = [self.history.text rangeOfString:@" ="];
    if (location.location != NSNotFound)
        self.history.text = [[self.history.text substringToIndex:location.location]
                             stringByAppendingString:[self.history.text
                                                      substringFromIndex:location.location + location.length]];
}


- (IBAction)digitPressed:(UIButton *)sender
{
    if (!self.userIsEnteringNumbers
        || ([self.display.text isEqualToString:@"0"]
        && ![sender.currentTitle isEqualToString:@"."]))
        self.display.text = @"";
    
    if ([sender.currentTitle isEqualToString:@"."]
        && [self.display.text rangeOfString:@"."].location != NSNotFound)
        return;
    
    [self displayMayNotReflectResult];
    self.userIsEnteringNumbers = YES;
    self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
}


- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsEnteringNumbers)
        [self enterPressed];
    
    self.display.text = [NSString stringWithFormat:@"%g", [self.engine performOperation:sender.currentTitle]];
    [self updateHistory];
}


- (IBAction)enterPressed
{
    [self.engine pushOperand:[self.display.text doubleValue]];
    [self updateHistory];
    
    self.userIsEnteringNumbers = NO;
}


- (IBAction)clearPressed
{
    [self.engine clearStack];
    
    self.display.text = @"0";
    self.history.text = @"0";
    
    self.userIsEnteringNumbers = NO;
}


- (IBAction)backspacePressed
{
    [self displayMayNotReflectResult];
    
    if (self.display.text.length == 1)
        self.display.text = @"0";
    else
        self.display.text = [self.display.text substringToIndex:(self.display.text.length - 1)];
}


- (IBAction)invertSignPressed
{
    [self displayMayNotReflectResult];
    
    if (![self.display.text isEqualToString:@"0"])
        self.display.text = [NSString stringWithFormat:@"%g", (-1 * [self.display.text doubleValue])];
}

@end
