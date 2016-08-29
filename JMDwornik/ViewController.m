//
//  ViewController.m
//  JMDwornik
//
//  Created by FBI on 16/3/28.
//  Copyright © 2016年 君陌. All rights reserved.
//

#import "ViewController.h"
#import "NumBoardView.h"

@interface ViewController ()<NumBoardViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _numView.delegate = self;

    [self recoverLastGameLayout];
    
    [self addGesture];
}

#pragma mark - 恢复上次游戏的布局(如果可以)
- (void) recoverLastGameLayout{
    
    NSString * currentScore = [[UserDefault objectForKey:CurrentScore] integerValue] ? [[UserDefault objectForKey:CurrentScore] stringValue] : @"0";
    NSString * topScore = [[UserDefault objectForKey:TopScore] integerValue] ? [[UserDefault objectForKey:TopScore] stringValue] : @"0";
    _currentScoreLabel.text = currentScore;
    _topScoreLabel.text = topScore;
    
    NSMutableDictionary * existDict = [NSMutableDictionary dictionary];
    
    NSDictionary * tempDict = [UserDefault objectForKey:ExistNumBoard];
    for (NSString * key in tempDict.allKeys) {
        [existDict setObject:[tempDict objectForKey:key] forKey:@([key integerValue])];
    }
    
    if (existDict.allKeys.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_numView recoverLastGameNumBoardView:existDict];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_numView createRandomNumLabel];
            [_numView createRandomNumLabel];
        });
    }
}

#pragma mark - 加载手势
- (void) addGesture{
    UISwipeGestureRecognizer * upSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabels:)];
    upSwipeGes.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upSwipeGes];
    
    UISwipeGestureRecognizer * downSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabels:)];
    downSwipeGes.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downSwipeGes];
    
    UISwipeGestureRecognizer * leftSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabels:)];
    leftSwipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGes];
    
    UISwipeGestureRecognizer * rightSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabels:)];
    rightSwipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGes];
}

#pragma mark - 手势事件
- (void) moveLabels:(UISwipeGestureRecognizer *) swipeGes{
    NSInteger index;
    
    if (swipeGes.direction == UISwipeGestureRecognizerDirectionUp) {
        index = 0;
    } else if (swipeGes.direction == UISwipeGestureRecognizerDirectionDown) {
        index = 1;
    } else if (swipeGes.direction == UISwipeGestureRecognizerDirectionLeft) {
        index = 2;
    } else {
        index = 3;
    }
    [_numView handleLabelArrDirection:index];
}

#pragma mark - 按钮点击
- (IBAction)btnClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//重新排列
            
        }
            break;
        case 1:{//后退一步
            [_numView goForwardLayout];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - NumBoardViewDelegate
- (void) currentScoreHasBeenChange:(NSInteger)currentScore topScore:(NSInteger)topScore{
    
    if (currentScore) {
        _currentScoreLabel.text = [NSString stringWithFormat:@"%ld",currentScore];
    }
    
    if (topScore) {
        [UserDefault setObject:@(topScore) forKey:TopScore];
        [UserDefault synchronize];
        _topScoreLabel.text = [NSString stringWithFormat:@"%ld",topScore];
    }
}

@end
