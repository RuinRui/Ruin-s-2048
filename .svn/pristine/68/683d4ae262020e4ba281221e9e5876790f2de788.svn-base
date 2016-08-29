//
//  NumBoardView.m
//  JMDwornik
//
//  Created by FBI on 16/3/28.
//  Copyright © 2016年 君陌. All rights reserved.
//

#import "NumBoardView.h"

#import "NumLabel.h"

#define horSpace 5
#define verSpace 5
#define NumLabelRect(index, viewWidth) CGRectMake(horSpace + (index % 4) * (horSpace + viewWidth), verSpace + (index / 4) * (verSpace + viewWidth), viewWidth, viewWidth)

#define Duration 0.3

@implementation NumBoardView{
    //是否在运动中
    BOOL _isSwipe;
    /**
     *  是否需要重新生成label
     */
    BOOL _needGenerateNewLabel;
    /**
     *  移动音效 播放器
     */
    AVAudioPlayer * _movePlayer;
    /**
     *  合并音效 播放器
     */
    AVAudioPlayer * _mergePlayer;
}

- (void) awakeFromNib{
    
    _backArr = [NSMutableArray arrayWithCapacity:10];
    _existIndexDict = [NSMutableDictionary dictionary];
    _changeNumsArr = [NSMutableArray array];
    _removeLabelsArr = [NSMutableArray array];
    
    _mergePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"merge" ofType:@"wav"]] error:nil];
    _movePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"move" ofType:@"wav"]] error:nil];
}

#pragma mark - 创造数字盘
- (void) drawRect:(CGRect)rect{
    
    static NSInteger i = 0;
    if (!(i ++)) {
        
        CGFloat viewWidth = (CGRectGetHeight(self.frame) - horSpace * 5 ) / 4.0;
        
        for (NSInteger i = 0; i < 16; i ++) {
            
            CGRect rect = NumLabelRect(i, viewWidth);
            
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
            
            [RGBColor(200, 200, 200) setFill];
            
            [path fill];
        }
    }
}

#pragma mark - 恢复游戏中的数字盘
- (void) recoverLastGameNumBoardView:(NSDictionary *) dict{
    
    _existIndexDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSMutableArray * tempLabelArr = [NSMutableArray array];
    for (NSNumber * number in _existIndexDict.allKeys) {
        
        CGFloat viewWidth = (CGRectGetHeight(self.frame) - horSpace * 5 ) / 4.0;
        
        NSInteger index = [number integerValue];
        
        CGRect rect = NumLabelRect(index, viewWidth);
        //创建Label
        NumLabel * label = [[NumLabel alloc] initWithFrame:rect];
        label.number = [_existIndexDict objectForKey:number];
        label.tag = index + 10;
        label.alpha = 0;
        
        [self addSubview:label];
        
        [tempLabelArr addObject:label];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UILabel * label in tempLabelArr) {
            label.alpha = 1;
        }
    } completion:^(BOOL finished) {
        JMKeyWindow.userInteractionEnabled = YES;
    }];
    
}

#pragma mark - 创造随机位置的数字（除了已经存在的数字占用的位置）
- (void) createRandomNumLabel{
    
    BOOL isExist = YES;
    NSInteger index = 0;
    //找出没有label存在的下标
    while (isExist) {
        index = arc4random() % 16;
        isExist = [[_existIndexDict allKeys] containsObject:[NSNumber numberWithInteger:index]];
    }
    
    CGFloat viewWidth = (CGRectGetHeight(self.frame) - horSpace * 5 ) / 4.0;
    
    CGRect rect = NumLabelRect(index, viewWidth);
    //创建Label
    NumLabel * label = [[NumLabel alloc] initWithFrame:rect];
    if (arc4random() % 16 < 2) {
        label.number = @(4);
    } else {
        label.number = @(2);
    }
    label.alpha = 0;
    label.transform = CGAffineTransformMakeScale(0, 0);
    label.tag = index + 10;
    
    [self addSubview:label];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.alpha = 1;
        label.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
    
    //把新坐标加入到字典中
    [_existIndexDict setObject:label.number forKey:@(index)];
}

#pragma mark - 对反悔数组的操作
- (void) handleBackArr{
    [_backArr addObject:[NSMutableDictionary dictionaryWithDictionary:_existIndexDict]];
    //如果反悔的数组超过十则移除最早的坐标字典 也就是说最多 返回十步
    if (_backArr.count > 10) {
        [_backArr removeObject:[_backArr firstObject]];
    }
}

#pragma mark - 返回上一步
- (void) goForwardLayout{
    
    if (_backArr.count > 1) {
        
        JMKeyWindow.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            for (id anything in self.subviews) {
                if ([anything isKindOfClass:[UILabel class]]) {
                    [(UILabel *)anything setAlpha:0];
                }
            }
        } completion:^(BOOL finished) {
            for (id anything in self.subviews) {
                [anything removeFromSuperview];
            }
            [self recoverLastGameNumBoardView:[_backArr lastObject]];
            [_backArr removeLastObject];
        }];
        
    } else {
        NSLog(@"不能在返回了");
    }
}

#pragma mark - 合并相邻的label 每次运动保存运动前的坐标点，以便于反悔
/**
 *
 *  @param direction 方向
 */
- (void) handleLabelArrDirection:(NSInteger ) direction{
    
    _needGenerateNewLabel = NO;
    //在移动之前先保存数据到backArr
    [self handleBackArr];
    
    if (!_movePlayer.playing) {
        [_movePlayer prepareToPlay];
        [_movePlayer play];
    }
    
    if (!_isSwipe) {
        
        _direction = direction;
        
        BOOL vertical = NO;
        if (direction == 0 || direction == 1) {
            vertical = YES;
        }
        
        //计算横竖排数量
        [self calculateLabelNumVertical:vertical];
    }
}

#pragma mark - 计算横排或者竖排的数量 
/**
 *
 *  @param vertical 是否是垂直方向移动
 */
- (void) calculateLabelNumVertical:(BOOL) vertical{
    //向上滑上面的坐标优先合并
    NSArray * verArr = @[@(0),@(1),@(2),@(3)];
    //向左滑左面的坐标优先合并
    NSArray * horArr = @[@(0),@(4),@(8),@(12)];
    
    //记录 遍历的 下标
    NSInteger indexNum = 0;
    for (NSNumber * number in (vertical ? verArr : horArr)) {
        
        //每行或者每列label的个数
        NSInteger num = 0;
        //坐标终点 当每行只有一个时候
        NSInteger index = [number integerValue];
        if (_direction == 1 || _direction == 3) {
            //当向下或者向右运动时候,终点坐标变化
            index = (_direction == 1 ? [number integerValue] + 12 : [number integerValue] + 3);
        }
        //记录最新的已存在的坐标包含的坐标位置
        NSInteger indexPosition = 0;
        for (NSInteger i = 0; i < 4; i ++) {
            
            NSInteger postion = (index + (vertical ? i * 4 : i));
            if (_direction == 1 || _direction == 3) {
                postion = index - (_direction == 1 ?  i * 4 : i);
            }
            if ([[_existIndexDict allKeys] containsObject:@(postion)]) {
                //当此位置有label时加1
                num ++;
                indexPosition = postion;
            }
        }
        
        if (num == 1) {//如果每行或者每列只有一个label
            if (index == indexPosition) {
                indexNum ++;
                continue;
            }
            _needGenerateNewLabel = YES;
            [_existIndexDict setObject:[_existIndexDict objectForKey:@(indexPosition)] forKey:@(index)];
            [_existIndexDict removeObjectForKey:@(indexPosition)];
            [self moveIndex:indexPosition endIndex:index clear:NO];
            
        } else if(num > 1) {//有多个则检测 并 合并相邻label
            [self combineLabelsArr:indexNum];
        }
        
        indexNum ++;
    }
    
    if (_needGenerateNewLabel) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createRandomNumLabel];
        });
    }
}

#pragma mark - 两个点之间Label的移动
/**
 *
 *  @param orginIndex 起点坐标
 *  @param endIndex   终点坐标
 *  @param isClear    是否清除起点坐标的label
 */
- (void) moveIndex:(NSInteger) orginIndex endIndex:(NSInteger) endIndex clear:(BOOL) isClear{
    
    _needGenerateNewLabel = YES;
    
    CGFloat viewWidth = (CGRectGetHeight(self.frame) - horSpace * 5 ) / 4.0;
    
    NumLabel * label = [self viewWithTag:orginIndex + 10];
    if (!isClear) {
        label.tag = endIndex + 10;
    }
    
    [UIView animateWithDuration:Duration animations:^{
        label.frame = NumLabelRect(endIndex, viewWidth);
    } completion:^(BOOL finished) {
        if (isClear) {
//            NumLabel * beginlabel = [self viewWithTag:orginIndex + 10];
//            [beginlabel removeFromSuperview];
//            
//            NumLabel * endLabel = [self viewWithTag:endIndex + 10];
//            endLabel.number = [_existIndexDict objectForKey:@(endIndex)];
        }
    }];
}

#pragma mark - 合并相邻的label - 向左合并
/**
 *
 *  @param indexNum 需要合并第几行或者第几列下标
 */
- (void) combineLabelsArr:(NSInteger) indexNum{
    
    if (_direction == 2 || _direction == 3) {
        [self leftOrRightCombineLabel:indexNum];
    } else {
        [self upOrDownCombineLabel:indexNum];
    }

    _isSwipe = NO;
//    //结束运动开始移除该移除的label和改变数值
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        for (NSNumber * number in _removeLabelsArr) {
//            NumLabel * label = [self viewWithTag:[number integerValue] + 10];
//            [label removeFromSuperview];
//        }
//        
//        for (NSNumber * number in _changeNumsArr) {
//            NumLabel * label = [self viewWithTag:[number integerValue] + 10];
//            label.number = [_existIndexDict objectForKey:number];
//        }
//        
//        [_removeLabelsArr removeAllObjects];
//        [_changeNumsArr removeAllObjects];
//    });
}

#pragma mark - 向左右合并label
/**
 *
 *  @param indexNum 需要合并行数下标
 */
- (void) leftOrRightCombineLabel:(NSInteger) indexNum{
    
    //向左滑左面的坐标优先合并
    NSArray * leftArr = @[@(0),@(4),@(8),@(12)];
    //向右滑右面的坐标优先合并
    NSArray * rightArr = @[@(3),@(7),@(11),@(15)];
    
    for (NSInteger j = 0; j < 3; j ++) {
        NSInteger horLeftIndex = _direction == 2 ? ([leftArr[indexNum] integerValue] + j) : ([rightArr[indexNum] integerValue] - j);
        //indexNum排的第j个的坐标是否存在label
        if ([[_existIndexDict allKeys] containsObject:@(horLeftIndex)]) {
            NSInteger leftIndexValue = [[_existIndexDict objectForKey:@(horLeftIndex)] integerValue];
            //如果存在,判断下一个是否存在,存在则继续判断下标差值,如果大于1则需要检测两者中间是否存在其他label
            for (NSInteger k = horLeftIndex + (_direction == 2 ? 1 : - 1); _direction == 2 ? (k < horLeftIndex - j + 4) : (k > horLeftIndex + j - 4); _direction == 2 ? k ++ : k --) {
                if ([[_existIndexDict allKeys] containsObject:@(k)]) {
                    NSInteger kIndexValue = [[_existIndexDict objectForKey:@(k)] integerValue];
                    if (kIndexValue == leftIndexValue) {//有同等数值的两个label
                        
                        if (k - horLeftIndex == 1 || k - horLeftIndex == - 1) {
                            //相邻存在可合并的label,移动并合并
                            [self fromIndex:k endIndex:horLeftIndex value:leftIndexValue];
                            //只要合并就跳过合并的label的下标，从此下标下一个开始
                            break;
                        } else if (k - horLeftIndex == 2 || k - horLeftIndex == - 2) {
                            //坐标相差为2检测中间是否有,有则Pass,没有则合并
                            if ([[_existIndexDict allKeys] containsObject:@(_direction == 2 ? (k - 1) : (k + 1))]) {
                                continue;
                            } else {
                                
                                [self fromIndex:k endIndex:horLeftIndex value:leftIndexValue];
                                //只要合并就跳过合并的label的下标，从此下标下一个开始
                                break;
                            }
                        } else {
                            //坐标相差为3检测中间是否有,有则Pass,没有则合并
                            if (![[_existIndexDict allKeys] containsObject:@(_direction == 2 ? (k - 1) : (k + 1))] && ![[_existIndexDict allKeys] containsObject:@(_direction == 2 ? (k - 2) : (k + 2))]) {
                                
                                [self fromIndex:k endIndex:horLeftIndex value:leftIndexValue];
                                //只要合并就跳过合并的label的下标，从此下标下一个开始
                                break;
                            } else {
                                continue;
                            }
                        }
                    }
                }
            }
        } else {
            continue;
        }
    }
    //合并后移动label   移动的终点坐标
    NSInteger moveIndex = (_direction == 2 ? [leftArr[indexNum] integerValue] : [rightArr[indexNum] integerValue]);
    for (NSInteger j = 0; j < 4; j ++) {
        NSInteger horLeftIndex = (_direction == 2 ? ([leftArr[indexNum] integerValue] + j) : ([rightArr[indexNum] integerValue] - j));
        //indexNum排的第j个的坐标是否存在label
        if ([[_existIndexDict allKeys] containsObject:@(horLeftIndex)]) {
            //如果存在
            if (horLeftIndex != moveIndex) {
                [self moveIndex:horLeftIndex endIndex:moveIndex clear:NO];
                [_existIndexDict setObject:[_existIndexDict objectForKey:@(horLeftIndex)] forKey:@(moveIndex)];
                [_existIndexDict removeObjectForKey:@(horLeftIndex)];
            }
            
            _direction == 2 ? moveIndex ++ : moveIndex --;
        }
    }
}

#pragma mark - 向上下合并 label
/**
 *
 *  @param indexNum 需要合并列数下标
 */
- (void) upOrDownCombineLabel:(NSInteger) indexNum{

    //向上滑上面的坐标优先合并
    NSArray * upArr = @[@(0),@(1),@(2),@(3)];
    //向下滑下面的坐标优先合并
    NSArray * downArr = @[@(12),@(13),@(14),@(15)];
    
    for (NSInteger j = 0; j < 13; j += 4) {
        NSInteger horLeftIndex = _direction == 0 ? ([upArr[indexNum] integerValue] + j) : ([downArr[indexNum] integerValue] - j);
        //indexNum排的第j个的坐标是否存在label
        if ([[_existIndexDict allKeys] containsObject:@(horLeftIndex)]) {
            NSInteger leftIndexValue = [[_existIndexDict objectForKey:@(horLeftIndex)] integerValue];
            //如果存在,判断下一个是否存在,存在则继续判断下标差值,如果大于1则需要检测两者中间是否存在其他label
            for (NSInteger k = horLeftIndex + (_direction == 0 ? 4 : - 4); _direction == 0 ? (k < horLeftIndex - j + 13) : (k > horLeftIndex + j - 13); _direction == 0 ? (k += 4) : (k -= 4)) {
                if ([[_existIndexDict allKeys] containsObject:@(k)]) {
                    NSInteger kIndexValue = [[_existIndexDict objectForKey:@(k)] integerValue];
                    if (kIndexValue == leftIndexValue) {
                        
                        if (k - horLeftIndex == 4 || k - horLeftIndex == - 4) {
                            //相邻存在可合并的label,移动并合并
                            [self fromIndex:k endIndex:horLeftIndex value:leftIndexValue];
                            //只要合并就跳过合并的label的下标，从此下标下一个开始
                            break;
                        } else if (k - horLeftIndex == 8 || k - horLeftIndex == - 8) {
                            //坐标相差为2检测中间是否有,有则Pass,没有则合并
                            if ([[_existIndexDict allKeys] containsObject:@(_direction == 0 ? (k - 4) : (k + 4))]) {
                                continue;
                            } else {
                                
                                [self fromIndex:k endIndex:horLeftIndex value:leftIndexValue];
                                //只要合并就跳过合并的label的下标，从此下标下一个开始
                                break;
                            }
                        } else {
                            //坐标相差为3检测中间是否有,有则Pass,没有则合并
                            if (![[_existIndexDict allKeys] containsObject:@(_direction == 0 ? (k - 4) : (k + 4))] && ![[_existIndexDict allKeys] containsObject:@(_direction == 0 ? (k - 8) : (k + 8))]) {
                                
                                [self fromIndex:k endIndex:horLeftIndex value:leftIndexValue];
                                //只要合并就跳过合并的label的下标，从此下标下一个开始
                                break;
                            } else {
                                continue;
                            }
                        }
                    }
                }
            }
        } else {
            continue;
        }
    }
    //合并后移动label   移动的终点坐标
    NSInteger moveIndex = (_direction == 0 ? [upArr[indexNum] integerValue] : [downArr[indexNum] integerValue]);
    for (NSInteger j = 0; j < 13; j += 4) {
        NSInteger horLeftIndex = (_direction == 0 ? ([upArr[indexNum] integerValue] + j) : ([downArr[indexNum] integerValue] - j));
        //indexNum排的第j个的坐标是否存在label
        if ([[_existIndexDict allKeys] containsObject:@(horLeftIndex)]) {
            //如果存在
            if (horLeftIndex != moveIndex) {
                [self moveIndex:horLeftIndex endIndex:moveIndex clear:NO];
                
                [_existIndexDict setObject:[_existIndexDict objectForKey:@(horLeftIndex)] forKey:@(moveIndex)];
                [_existIndexDict removeObjectForKey:@(horLeftIndex)];
            }
            
            _direction == 0 ? (moveIndex += 4) : (moveIndex -= 4);
        }
    }
}

#pragma mark - 移动并合并label的数据操作
/**
 *
 *  @param beginIndex 起点坐标
 *  @param index      终点坐标
 *  @param value      终点坐标的数值
 */
- (void) fromIndex:(NSInteger) orginIndex endIndex:(NSInteger) index value:(NSInteger) value{
    
    [self moveIndex:orginIndex endIndex:index clear:YES];
  
    NumLabel * beginlabel = [self viewWithTag:orginIndex + 10];
    [beginlabel removeFromSuperview];
    
    NumLabel * endLabel = [self viewWithTag:index + 10];
    endLabel.number = @(2 * value);
    
    [_existIndexDict setObject:@(2 * value) forKey:@(index)];
    [_existIndexDict removeObjectForKey:@(orginIndex)];
    
    if (!_mergePlayer.playing) {
        [_mergePlayer prepareToPlay];
        [_mergePlayer play];
    }
    
    [self handleScore:index];
}

#pragma mark - 得到当前分数和最高分数
- (void) handleScore:(NSInteger) index{
    
    NSNumber * lastScore = [UserDefault objectForKey:CurrentScore];
    NSNumber * lastTopScore = [UserDefault objectForKey:TopScore];
    
    NSInteger currentScore = [[_existIndexDict objectForKey:@(index)] integerValue] + [lastScore integerValue];
    [UserDefault setObject:@(currentScore) forKey:CurrentScore];
    [UserDefault synchronize];
    
    NSInteger topScore = currentScore > [lastTopScore integerValue] ? currentScore : 0;
    
    if ([_delegate respondsToSelector:@selector(currentScoreHasBeenChange:topScore:)]) {
        [_delegate currentScoreHasBeenChange:currentScore topScore:topScore];
    }
}

@end
