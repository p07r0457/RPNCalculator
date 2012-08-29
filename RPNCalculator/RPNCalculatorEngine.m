//
//  RPNCalculatorEngine.m
//  RPNCalculator
//
//  Created by Kyle Maher on 8/26/12.
//  Copyright (c) 2012 Kyle Maher. All rights reserved.
//

#import "RPNCalculatorEngine.h"

@interface RPNCalculatorEngine()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end


@implementation RPNCalculatorEngine


@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (_operandStack == nil)
        _operandStack = [[NSMutableArray alloc] init];
    
    return _operandStack;
}


- (void)clearStack
{
    [self.operandStack removeAllObjects];
}


- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}


- (double)popOperand
{
    NSNumber *lastOperand = [self.operandStack lastObject];
    
    if (lastOperand)
        [self.operandStack removeLastObject];
    
    return [lastOperand doubleValue];
}


- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"])
        result = self.popOperand + self.popOperand;
    else if ([operation isEqualToString:@"-"])
    {
        double secondOperand = self.popOperand;
        result = self.popOperand - secondOperand;
    }
    else if ([operation isEqualToString:@"*"])
        result = self.popOperand * self.popOperand;
    else if ([operation isEqualToString:@"/"])
    {
        double secondOperand = self.popOperand;
        result = self.popOperand / secondOperand;
    }
    else if ([operation isEqualToString:@"sin"])
        result = sin(self.popOperand);
    else if ([operation isEqualToString:@"cos"])
        result = cos(self.popOperand);
    else if ([operation isEqualToString:@"tan"])
        result = tan(self.popOperand);
    else if ([operation isEqualToString:@"π"])
        result = M_PI;
    else if ([operation isEqualToString:@"√"])
        result = sqrt(self.popOperand);
    else if ([operation isEqualToString:@"x^2"])
        result = pow(self.popOperand, 2);
    else if ([operation isEqualToString:@"x^3"])
        result = pow(self.popOperand, 3);
    else if ([operation isEqualToString:@"x^y"])
    {
        double secondOperand = self.popOperand;
        result = pow(self.popOperand, secondOperand);
    }
    
    [self pushOperand:result];
    
    return result;
}

@end
