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
@property (strong,nonatomic) NSDictionary *variableValues;
@end

@implementation ViewController

@synthesize display = _display;
@synthesize stackDisplay = _stackDisplay;
@synthesize varDisplay = _varDisplay;
@synthesize isUserInTheMiddleOfTyping = _isUserInTheMiddleOfTyping;
@synthesize variableValues = _variableValues;
@synthesize brain = _brain;

- (CalculatorBrain *) brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (void) updateDisplay:(double)result {
    self.display.text = [NSString stringWithFormat:@"%g",result];
}

- (IBAction)updateVariables:(UIButton *)sender {
    NSString *tempDescription;
    
    if ([sender.currentTitle isEqual:@"t1"]) {
        self.variableValues =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"x",[NSNumber numberWithInt:3],@"a", nil];
    } else if ([sender.currentTitle isEqual:@"t2"]) {
        self.variableValues =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:4],@"x",[NSNumber numberWithInt:5],@"b", nil];
    } else if ([sender.currentTitle isEqual:@"t3"]) {
        self.variableValues =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:9],@"a",[NSNumber numberWithInt:7],@"b", nil];
    }
    
    tempDescription = [self.variableValues description];
    tempDescription = [tempDescription stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.varDisplay.text = tempDescription;
    
    [self  updateDisplay:[self.brain performOperation:nil usingVariableValues:self.variableValues]];
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
    
    if (self.isUserInTheMiddleOfTyping) {
        [self enterPressed];
    }
    
    [self updateDisplay:[self.brain performOperation:sender.currentTitle usingVariableValues:self.variableValues]];
    [self updateStackDisplay];
}

@end
