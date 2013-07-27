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
@synthesize stackDisplay = _stackDisplay;
@synthesize isUserInTheMiddleOfTyping = _isUserInTheMiddleOfTyping;
@synthesize brain = _brain;

- (CalculatorBrain *) brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = sender.currentTitle;
    
    if (self.isUserInTheMiddleOfTyping) {
        if (![digit isEqual:@"."] || [self.display.text rangeOfString:@"."].location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    } else {
        self.display.text = digit;
        self.isUserInTheMiddleOfTyping = YES;
    }
}

- (void) updateStackDisplay {
    self.stackDisplay.text = [self.brain description];
}

- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushOperandObj:sender.currentTitle];
    [self updateStackDisplay];
}

- (IBAction)cancelPressed {
    [self.brain clearMemory];
    self.display.text = @"0";
    [self updateStackDisplay];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.isUserInTheMiddleOfTyping = NO;
    [self updateStackDisplay];
}

- (IBAction)operationPressed:(UIButton *)sender {
    double result;
    
    if (self.isUserInTheMiddleOfTyping) {
        [self enterPressed];
    }
    
    result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    
    [self updateStackDisplay];
}

@end
