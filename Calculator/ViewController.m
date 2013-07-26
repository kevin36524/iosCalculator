//
//  ViewController.m
//  Calculator
//
//  Created by Kevin Patel on 7/25/13.
//  Copyright (c) 2013 Kevin Patel. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (assign,nonatomic) BOOL isUserInTheMiddleOfTyping;
@property (strong,nonatomic) CalculatorBrain *brain;
@end

@implementation ViewController

@synthesize display = _display;
@synthesize isUserInTheMiddleOfTyping = _isUserInTheMiddleOfTyping;
@synthesize brain = _brain;

- (CalculatorBrain *) brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if (self.isUserInTheMiddleOfTyping) {
        self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
    } else {
        self.display.text = sender.currentTitle;
        self.isUserInTheMiddleOfTyping = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.isUserInTheMiddleOfTyping = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    double result;
    
    if (self.isUserInTheMiddleOfTyping) {
        [self enterPressed];
    }
    
    result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g",result];
}

@end
