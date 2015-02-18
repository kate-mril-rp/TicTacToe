//
//  ViewController.m
//  ticTacToe
//
//  Created by Kate on 2/13/15.
//  Copyright (c) 2015 game. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@end

@implementation ViewController
int computer_move;
int MAX_SCORE;
int MIN_SCORE;

NSString *O_PLAYER;
NSString *X_PLAYER;
NSString *EMPTY;

NSMutableArray *board;
NSArray *buttons;

int DRAW;
bool computerTurnEvaluationIsInProgress;
bool gameOver;

- (void)viewDidLoad {
    [super viewDidLoad];

    board = [[NSMutableArray alloc]init];
    NSArray *emptyBoard = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];
    [board addObjectsFromArray:emptyBoard];
    buttons = @[_button0, _button1, _button2, _button3, _button4, _button5, _button6, _button7, _button8];
    
    MAX_SCORE = 1;
    MIN_SCORE = -1;
    DRAW = 0;
    
    O_PLAYER = @"O";
    X_PLAYER = @"X";
    EMPTY = @"";
    
    gameOver = false;
    computerTurnEvaluationIsInProgress = false;
}

#pragma mark - UIButton methods

- (IBAction)button:(id)sender {
    NSInteger tag = [sender tag];
    if (tag == 0) {
        [self  buttonClicked:sender index:0];
    } else if (tag == 1) {
        [self  buttonClicked:sender index:1];
    } else if (tag == 2) {
         [self  buttonClicked:sender index:2];
    } else if (tag == 3) {
        [self  buttonClicked:sender index:3];
    } else if (tag == 4) {
        [self  buttonClicked:sender index:4];
    } else if (tag == 5) {
        [self  buttonClicked:sender index:5];
    } else if (tag == 6) {
        [self  buttonClicked:sender index:6];
    } else if (tag == 7) {
        [self  buttonClicked:sender index:7];
    } else if (tag == 8) {
        [self  buttonClicked:sender index:8];
    }
}

- (void) buttonClicked:(id)sender index:(int)index {
    if (![board[index]isEqualToString:EMPTY]) {
        return;
    }
    if (computerTurnEvaluationIsInProgress) {
        return;
    }
    
    if (gameOver) {
        return;
    }
    
    board[index] = O_PLAYER;
    UIButton *button = (UIButton *)sender;
    [button setTitle:O_PLAYER forState:UIControlStateNormal];
    
    [self nextMove];
}

- (void) nextMove {
    computerTurnEvaluationIsInProgress = true;
    
    [self computerMove:board depth:0 alpha:-1 beta:1];
    [self board:board withValue:X_PLAYER atPosition:computer_move];
    
    UIButton *button = buttons[computer_move];
    [button setTitle:X_PLAYER forState:UIControlStateNormal];
    //[self printMatrix:board];
    
    if ([self checkPlayerWin:X_PLAYER withBoard:board]){
        [self showAlertWithMessage:@"Computer won"];
        gameOver = true;
    } else if ([self checkPlayerWin:O_PLAYER withBoard:board]){
        [self showAlertWithMessage:@"You won"];
        gameOver = true;
    } else if (![board containsObject:EMPTY]) {
        [self showAlertWithMessage:@"It is a draw"];
        gameOver = true;
    }
    
    computerTurnEvaluationIsInProgress = false;
}

- (IBAction)startOver:(id)sender {
    gameOver = false;
    [board removeAllObjects];
    NSArray *emptyBoard = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];
    [board addObjectsFromArray:emptyBoard];
    for (int i = 0; i < 9; i++) {
        [buttons[i] setTitle:@"" forState:UIControlStateNormal];
    }
}

#pragma mark - UIAlertController methods

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Board methods

- (void)board:(NSMutableArray *)board withValue:(NSString *)value atPosition:(int)position {
    board[position] = value;
}

- (NSString *)getCell:(int)i fromBoard:(NSMutableArray *)board {
    return board[i];
}

- (void)putCell:(int)i withPlayer:(NSString *)player intoBoard:(NSMutableArray *)board {
    board[i] = player;
}

#pragma mark - Next move evaluation methods

-(int)playerMove:(NSMutableArray *) board depth:(int)depth alpha:(int)alpha beta:(int)beta {
    int i, value;
    NSMutableArray *newBoard;
    int min = MAX_SCORE+1;
    if ([self checkPlayerWin:X_PLAYER withBoard:board]){
        return MAX_SCORE;
    }
    for (i=0; i< 9; i++) {
        if ([[self getCell:i fromBoard:board] isEqualToString:EMPTY]) {
            newBoard = [board mutableCopy];
            [self putCell:i withPlayer:O_PLAYER intoBoard:newBoard];
            //[self printMatrix:newBoard];
            value = [self computerMove:newBoard depth:depth+1 alpha:alpha beta:beta];
            if (value < min) {
                min = value;
            }
            
            if (value < beta) {
                beta = value;
            }
            if (alpha >= beta) {
                return beta;
            }

        }
    }
    if (min== MAX_SCORE+1) {
        return DRAW;
    }
    return min;
}

-(int)computerMove:(NSMutableArray *)board depth:(int)depth alpha:(int)alpha beta:(int)beta {
    int i, value;
    NSMutableArray *newBoard;
    int max = MIN_SCORE-1;
    if([self checkPlayerWin:O_PLAYER withBoard:board]) {
        return MIN_SCORE;
    }
    
    for(i=0; i < 9; i++){
        if([[self getCell:i fromBoard:board] isEqualToString:EMPTY]) {
            newBoard = [board mutableCopy];
            [self putCell:i withPlayer:X_PLAYER intoBoard:newBoard];
            //[self printMatrix:newBoard];
            value = [self playerMove:newBoard depth:depth+1 alpha:alpha beta:beta];
            if(value > max) {
                max = value;
                if(depth == 0) {
                    computer_move = i;
                }
            }
            if (value > alpha) {
                alpha = value;
            }
            if (alpha >= beta) {
                return alpha;
            }
        }
    }
    if(max == MIN_SCORE-1) {
        return DRAW;
    }
    return max;
}

- (BOOL)checkPlayerWin:(NSString *)player withBoard:(NSMutableArray *)board {
    if ([board[8] isEqualToString:player] && [board[7] isEqualToString:player] && [board[6] isEqualToString:player]) {
        return true;
    } else if ([board[5] isEqualToString:player] && [board[4] isEqualToString:player] && [board[3] isEqualToString:player]) {
        return true;
    } else if ([board[2] isEqualToString:player] && [board[1] isEqualToString:player] && [board[0] isEqualToString:player]) {
        return true;
    } else if ([board[8] isEqualToString:player] && [board[5] isEqualToString:player] && [board[2] isEqualToString:player]) {
        return true;
    } else if ([board[7] isEqualToString:player] && [board[4] isEqualToString:player] && [board[1] isEqualToString:player]) {
        return true;
    } else if ([board[6] isEqualToString:player] && [board[3] isEqualToString:player] && [board[0] isEqualToString:player]) {
        return true;
    } else if ([board[6] isEqualToString:player] && [board[4] isEqualToString:player] && [board[2] isEqualToString:player]) {
        return true;
    } else if ([board[8] isEqualToString:player] && [board[4] isEqualToString:player] && [board[0] isEqualToString:player]) {
        return true;
    } else {
        return false;
    }
    
}

#pragma mark - Convenience methods

- (void)printMatrix:(NSMutableArray *)board {
    NSString *row = [[NSString alloc]init];
    row = [row stringByAppendingString:@"\r"];
    for (int i = 0; i < 9; i++) {
        if (i == 3 || i == 6) {
            row = [row stringByAppendingString:@"\r"];
        }
            if ([board[i] isEqualToString:EMPTY]) {
                row = [row stringByAppendingString:@"_ "];
                
            } else {
                row = [row stringByAppendingString:board[i]];
                row = [row stringByAppendingString:@" "];
            }
    }
     NSLog(@"%@", row);
}

@end
