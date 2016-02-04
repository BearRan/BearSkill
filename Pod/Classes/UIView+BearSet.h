//
//  UIView+MySet.h
//
//  Created by bear on 15/11/25.
//  Copyright (c) 2015年 Bear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kAXIS_Y,
    kAXIS_X,
    kAXIS_X_Y,
}kAXIS;

typedef enum {
    kLAYOUT_AXIS_Y,
    kLAYOUT_AXIS_X,
}kLAYOUT_AXIS;

typedef enum {
    kDIR_LEFT,
    kDIR_RIGHT,
    kDIR_UP,
    kDIR_DOWN,
}kDIRECTION;


@interface UIView (MySet)

/**
 *  普通的方法
 */

// 毛玻璃效果处理
- (void)blurEffectWithStyle:(UIBlurEffectStyle)style Alpha:(CGFloat)alpha;

// 设置边框
- (void)setBorder:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

// 自定义分割线View OffY
- (void)setSeparatorLineOffY:(int)offStart offEnd:(int)offEnd lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor offY:(CGFloat)offY;

// 自定义底部分割线View
- (void)setSeparatorLine:(CGFloat)offStart offEnd:(CGFloat)offEnd lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;

// 通过view，画任意方向的线
- (void)drawLine:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;


// 通过layer，画任意方向的线
- (void)drawLineWithLayer:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;





/**
 *  布局扩展方法
 */


//  Getter

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)maxX;
- (CGFloat)maxY;
- (CGFloat)width;
- (CGFloat)height;
- (CGPoint)origin;
- (CGSize)size;

- (CGFloat)centerX;
- (CGFloat)centerY;


//Setter

- (void)setX:(CGFloat)x;
- (void)setMaxX:(CGFloat)maxX;
- (void)setMaxX_DontMoveMinX:(CGFloat)maxX;

- (void)setY:(CGFloat)y;
- (void)setMaxY:(CGFloat)maxY;
- (void)setMaxY_DontMoveMinY:(CGFloat)maxY;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)point;
- (void)setOrigin:(CGPoint)point sizeToFit:(BOOL)sizeToFit;
- (void)setSize:(CGSize)size;

- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;

- (void)setWidth_DonotMoveCenter:(CGFloat)width;
- (void)setHeight_DonotMoveCenter:(CGFloat)height;
- (void)setSize_DonotMoveCenter:(CGSize)size;
- (void)sizeToFit_DonotMoveSide:(kDIRECTION)dir centerRemain:(BOOL)centerRemain;


/**
 *  和父类view剧中
 *
 *  当前view和父类view的 X轴／Y轴／中心点 对其
 */
- (void)setCenterToParentViewWithAxis:(kAXIS)axis;


/**
 *  和指定的view剧中
 *
 *  当前view和指定view的 X轴／Y轴／中心点 对其
 */
- (void)setCenterToView:(UIView *)destinationView withAxis:(kAXIS)axis;



/**
 *  相对布局关系参考图
 *
 *
 *  self与destinationView 是是是是是 父子类关系
 *  大方框为destinationView，大方框为self的父类view
 *
 *     ----------     ----------     ----------     ----------
 *    |   self   |   |          |   |          |   |          |
 *    |          |   |          |   |          |   |          |
 *    |          |   |          |   |self      |   |      self|
 *    |          |   |          |   |          |   |          |
 *    |          |   |   self   |   |          |   |          |
 *     ----------     ----------     ----------     ----------
 *
 *
 *  关系： up             down          left           right
 *
 *
 *
 *  self与destinationView 非非非非 父子类关系
 *  大方框为destinationView和self所共有的父类view
 *
 *     ----------     ----------     ----------     ----------
 *    |   self   |   |   dest   |   |          |   |          |
 *    |          |   |          |   |          |   |          |
 *    |          |   |          |   |self  dest|   |dest  self|
 *    |          |   |          |   |          |   |          |
 *    |   dest   |   |   self   |   |          |   |          |
 *     ----------     ----------     ----------     ----------
 *
 *
 *  关系： up             down          left            right
 */

/**
 *  view与view的相对位置
 *
 *  direction:          方位
 *  destinationView:    目标view
 *  parentRelation:     是否为父子类关系
 *  distance:           距离
 *  center:             是否对应居中
 *
 *  此方法用于设置view与view之间的相对位置
 *  self与destinationView非父子类关系时: 可以设置self相对于destinationView的 上／下／左／右 的边距
 *  self与destinationView是父子类关系时: 可以设置self相对于父类view的 上／下／左／右 的间距
 *  注：parentRelation==YES时，destinationView可以设为nil。
 */
- (void)setRelativeLayoutWithDirection:(kDIRECTION)direction destinationView:(UIView *)destinationView parentRelation:(BOOL)parentRelation distance:(CGFloat)distance center:(BOOL)center;



/**
 *  view与view的相对位置
 *
 *  带sizeToFit
 */
- (void)setRelativeLayoutWithDirection:(kDIRECTION)direction destinationView:(UIView *)destinationView parentRelation:(BOOL)parentRelation distance:(CGFloat)distance center:(BOOL)center sizeToFit:(BOOL)sizeToFit;





//  Bear根据子view自动布局-scrollView
+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray parentScrollView:(UIScrollView *)parentScrollView offStart:(CGFloat)offStart offEnd:(CGFloat)offEnd center:(BOOL)center layoutAxis:(kLAYOUT_AXIS)layoutAxis;

//  Bear根据子view自动布局
+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray layoutAxis:(kLAYOUT_AXIS)layoutAxis center:(BOOL)center offStart:(CGFloat)offStart offEnd:(CGFloat)offEnd;

//  Bear根据子view自动布局-根据间距自动布局
+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray layoutAxis:(kLAYOUT_AXIS)layoutAxis center:(BOOL)center gapDistance:(CGFloat)gapDistance;

@end
