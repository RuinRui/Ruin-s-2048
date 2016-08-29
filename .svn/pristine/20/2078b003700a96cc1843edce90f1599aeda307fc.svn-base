//
//  NumBoardView.h
//  JMDwornik
//
//  Created by FBI on 16/3/28.
//  Copyright © 2016年 君陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumBoardViewDelegate <NSObject>

- (void) currentScoreHasBeenChange:(NSInteger) currentScore topScore:(NSInteger) topScore;

@end

@interface NumBoardView : UIView{
    //是否向上或者向左滑动 上下左右
    NSInteger _direction;
}

/**
 *  key: 位置下标  value:lable的数值  记录合并后的label的位置
 */
@property (nonatomic, strong) NSMutableDictionary * existIndexDict;
/**
 *  存储需要移除的 label的下标
 */
@property (nonatomic, strong) NSMutableArray * removeLabelsArr;
/**
 *  存储需要 改变数值的label 的下标
 */
@property (nonatomic, strong) NSMutableArray * changeNumsArr;
/**
 *  后悔的步骤,最多10步
 */
@property (nonatomic, strong) NSMutableArray * backArr;

@property (nonatomic, assign) id <NumBoardViewDelegate> delegate;
/**
 *  创建随机的数字
 */
- (void) createRandomNumLabel;
/**
 *  按方向处理 数字
 *
 *  @param direction 上下左右方向
 */
- (void) handleLabelArrDirection:(NSInteger ) direction;
/**
 *  恢复游戏的数字盘
 *
 *  @param dict 存储游戏数字盘的数据的字典
 */
- (void) recoverLastGameNumBoardView:(NSDictionary *) dict;
/**
 *  返回上一次 游戏的布局
 */
- (void) goForwardLayout;

@end
