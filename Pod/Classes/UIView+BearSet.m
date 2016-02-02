//
//  BearConstants.h
//  Bear
//
//  Created by Bear on 30/12/24.
//  Copyright © 2015年 Bear. All rights reserved.
//

#import "UIView+BearSet.h"

@implementation UIView (BearSet)

#pragma mark 设置边框
/*
 设置边框颜色和宽度
 */
- (void)setMyBorder:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

#pragma mark 自定义分割线View OffY
/*
 根据offY在任意位置画横向分割线
 */
- (void)setMySeparatorLineOffY:(int)offStart offEnd:(int)offEnd lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor offY:(CGFloat)offY
{
    int parentView_width    = CGRectGetWidth(self.frame);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offStart, offY, parentView_width - offStart - offEnd, lineWidth)];
    
    if (!lineColor) {
        lineView.backgroundColor = [UIColor blackColor];
    }else{
        lineView.backgroundColor = lineColor;
    }
    
    [self addSubview:lineView];
}

#pragma mark 自定义分底部割线View
/*
 自动在底部横向分割线
 */
- (void)setMySeparatorLine:(CGFloat)offStart offEnd:(CGFloat)offEnd lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
    CGFloat parentView_height   = CGRectGetHeight(self.frame);
    CGFloat parentView_width    = CGRectGetWidth(self.frame);
    
//    NSLog(@"kkkkk parentView_width:%f", parentView_width);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offStart, parentView_height - lineWidth, parentView_width - offStart - offEnd, lineWidth)];
    
    if (!lineColor) {
        lineView.backgroundColor = [UIColor blackColor];
    }else{
        lineView.backgroundColor = lineColor;
    }
    
    [self addSubview:lineView];
}

#pragma mark - 画线--View
/*
 通过view，画任意方向的线
 */
- (void) drawLine:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = lineColor;
    
    //竖线
    if (startPoint.x == endPoint.x) {
        lineView.frame = CGRectMake(startPoint.x, startPoint.y, lineWidth, endPoint.y - startPoint.y);
    }
    
    //横线
    else if (startPoint.y == endPoint.y){
        lineView.frame = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, lineWidth);
    }
    
    [self addSubview:lineView];
    
}

#pragma mark - 画线--Layer
/*
 通过layer，画任意方向的线
 */
- (void) drawLineWithLayer:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
    //1.获得图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();

    //将上下文复制一份到栈中
    CGContextSaveGState(context);

    //2.绘制图形
    //设置线段宽度
    CGContextSetLineWidth(context, lineWidth);
    //设置线条头尾部的样式
    CGContextSetLineCap(context, kCGLineCapRound);

    //设置颜色
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);

    //设置起点
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    //画线
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);

    //3.显示到View
    CGContextStrokePath(context);//以空心的方式画出

    //将图形上下文出栈，替换当前的上下文
    CGContextRestoreGState(context);
}

/*
 优化建议：
 1.status改为enum
 */
#pragma mark 和指定的view剧中
- (void)setCenterWithHorizontal:(BOOL)status parentView:(UIView *)parentView
{
    if (status) {
        self.center = CGPointMake(CGRectGetWidth(parentView.frame)/2, self.center.y);
    }else{
        self.center = CGPointMake(self.center.x, CGRectGetHeight(parentView.frame)/2);
    }
}

#pragma mark 和指定的view剧中(默认在父类view剧中)
- (void)setMyCenter:(Direction_HorVer)direction destinationView:(UIView *)destinationView parentRelation:(BOOL)parentRelation
{
    //父子类view关系
    if (parentRelation) {
        if (!destinationView) {
            destinationView = [self superview];
        }
        
        switch (direction) {
            case dir_Horizontal:
                self.center = CGPointMake(CGRectGetWidth(destinationView.frame)/2, self.center.y);
                break;
                
            case dir_Vertical:
                self.center = CGPointMake(self.center.x, CGRectGetHeight(destinationView.frame)/2);
            default:
                break;
        }
    }
    
    //非父子类view关系
    else{
        if (!destinationView) {
            NSLog(@"非父子类关系的view，并且没有目标view");
            return;
        }
        
        if (![self.superview isEqual:destinationView.superview]) {
            NSLog(@"非父子类关系的view，并且不属于同一个父类view");
            return;
        }
        
        switch (direction) {
            case dir_Horizontal:
                self.center = CGPointMake(self.center.x, destinationView.center.y);
                break;
                
            case dir_Vertical:
                self.center = CGPointMake(destinationView.center.x, self.center.y);
            default:
                break;
        }
    }
}

/*
    在父类view中的话,destinationView可为nil 设置位置约束，上下左右，是否父类view
 */
- (void)setMyDirectionDistance:(Direction_Four)direction destinationView:(UIView *)destinationView parentRelation:(BOOL)parentRelation distance:(CGFloat)distance center:(BOOL)center
{
    CGRect tempRect = self.frame;
    
    //在父类view中
    if (parentRelation) {
        if (!destinationView) {
            destinationView = [self superview];
        }
        
        switch (direction) {
                
            //上边距
            case dir_Up:{
                tempRect.origin.y = distance;
                self.frame = tempRect;
                if (center) {
                    [self setMyCenter:dir_Horizontal destinationView:destinationView parentRelation:YES];
                }
            }
                break;
              
            //下边距
            case dir_Down:{
                tempRect.origin.y = CGRectGetHeight(destinationView.frame) - CGRectGetHeight(self.frame) - distance;
                self.frame = tempRect;
                if (center) {
                    [self setMyCenter:dir_Horizontal destinationView:destinationView parentRelation:YES];
                }
            }
                
                break;
                
            //左边距
            case dir_Left:{
                tempRect.origin.x = distance;
                self.frame = tempRect;
                if (center) {
                    [self setMyCenter:dir_Vertical destinationView:destinationView parentRelation:YES];
                }
            }
                
                break;
              
            //右边距
            case dir_Right:{
                tempRect.origin.x = CGRectGetWidth(destinationView.frame) - CGRectGetWidth(self.frame) - distance;
                self.frame = tempRect;
                if (center) {
                    [self setMyCenter:dir_Vertical destinationView:destinationView parentRelation:YES];
                }
            }
                
                break;
                
            default:
                break;
        }
        
    }
    
    //不在父类view中，其他view
    /*    -----      -----
     *   | self |   | des  |
     *   |      |   |      |   -----------------    ------------------
     *   | up   |   | down |  | self  left  des |  | des  right  self |
     *   |      |   |      |   -----------------    ------------------
     *   | des  |   | self |
     *    -----      -----
     */
    else{
        switch (direction) {
            case dir_Up:
                tempRect.origin.y = CGRectGetMinY(destinationView.frame) - distance - CGRectGetHeight(self.frame);
                self.frame = tempRect;
                if (center) {
                    [self setMyCenter:dir_Vertical destinationView:destinationView parentRelation:NO];
                }
                
                break;
                
            case dir_Down:
                tempRect.origin.y = CGRectGetMaxY(destinationView.frame) + distance;
                self.frame = tempRect;
                if (center) {
                    [self setMyCenter:dir_Vertical destinationView:destinationView parentRelation:NO];
                }
                
                break;
                
            case dir_Left:
                tempRect.origin.x = CGRectGetMinX(destinationView.frame) - distance - CGRectGetWidth(self.frame);
                self.frame = tempRect;
                if (center) {
                    [self setMyCenter:dir_Horizontal destinationView:destinationView parentRelation:NO];
                }
                
                break;
                
            case dir_Right:
                tempRect.origin.x = CGRectGetMaxX(destinationView.frame) + distance;
                
                self.frame = tempRect;
                if (center) {
                    [self setMyCenter:dir_Horizontal destinationView:destinationView parentRelation:NO];
                }
                
                break;
                
            default:
                break;
        }
    }
}


//  设置宽
- (void)setMyWidth:(CGFloat)width
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

//  设置高
- (void)setMyHeight:(CGFloat)height
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

//  设置size
- (void)setMySize:(CGSize)size
{
    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}

//  设置x
- (void)setMyX:(CGFloat)x
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}

//  设置y
- (void)setMyY:(CGFloat)y
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}

//  设置centerX
- (void)setMyCenterX:(CGFloat)x
{
    CGPoint tempCenter = self.center;
    tempCenter.x = x;
    self.center = tempCenter;
}

//  设置centerY
- (void)setmyCenterY:(CGFloat)y
{
    CGPoint tempCenter = self.center;
    tempCenter.y = y;
    self.center = tempCenter;
}


//  不移动中心－设置width
- (void)setMyWidth_DonotMoveCenter:(CGFloat)width
{
    CGPoint tempCenter = self.center;
    [self setMyWidth:width];
    self.center = tempCenter;
}

//  不移动中心－设置height
- (void)setMyHeight_DonotMoveCenter:(CGFloat)height
{
    CGPoint tempCenter = self.center;
    [self setMyHeight:height];
    self.center = tempCenter;
}

//  不移动中心－设置height
- (void)setMySize_DonotMoveCenter:(CGSize)size
{
    CGPoint tempCenter = self.center;
    [self setMySize:size];
    self.center = tempCenter;
}


#pragma mark Bear根据子view自动布局-scrollView
/*
 viewArray:         装有子类view的数组
 parentView:        父类的view
 offStart:          起始点和边框的距离
 offEnd:            结束点和边框的距离
 centerEqualParent: 是否和父类的view剧中对其（YES：剧中对其，NO：不剧中对齐）
 horizontalOrNot:   是否水平自动布局（YES：水平方向自动布局，NO：垂直方向自动布局）
 offDistanceEqualViewDistance 边距和view之间的距离是否相等
 */
+ (void)BearHorizontalAutoLay:(NSMutableArray *)viewArray parentScrollView:(UIScrollView *)parentScrollView offStart:(CGFloat)offStart offEnd:(CGFloat)offEnd centerEqualParent:(BOOL)centerEqualParent horizontalOrNot:(BOOL)horizontalOrNot offDistanceEqualViewDistance:(BOOL)offDistanceEqualViewDistance
{
    int width_allSubV = 0;  //所有子view的宽总和
    int k = -1;             //设置边距距离是否和view的间距相等
    if (offDistanceEqualViewDistance) {
        k = 1;
    }
    
    if (horizontalOrNot) {
        
        /*
         水平方向自动布局
         */
        //获取所有子类view的宽度总和
        for (UIView *tempSubView in viewArray) {
            width_allSubV += tempSubView.frame.size.width;
        }
        
        if (parentScrollView.contentSize.width - width_allSubV >= offStart + offEnd) {
            /*
             可以使用宽度自动布局
             */
            CGFloat deltaX = (parentScrollView.contentSize.width - width_allSubV - offStart - offEnd)/([viewArray count] + k);//子view的x间距
            CGFloat tempX = offStart;//用于存储子view临时的X起点
            if (offDistanceEqualViewDistance) {
                tempX = deltaX;
            }
            for (int i = 0; i < [viewArray count]; i++) {
                UIView *tempSubView = viewArray[i];
                
                //给子view重新设定x起点
                CGRect tempFrame = tempSubView.frame;
                tempFrame.origin.x = tempX;
                tempSubView.frame = tempFrame;
                
                if (centerEqualParent) {
                    //竖直方向相对于父类view剧中
                    tempSubView.center = CGPointMake(tempSubView.center.x, parentScrollView.contentSize.height/2);
                }
                //tempX加上当前子view的width和deltaX
                tempX = tempX + CGRectGetWidth(tempSubView.bounds) + deltaX;
            }
        }else{
            
            /*
             无法使用自动布局
             */
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view宽总和:%d\noffStart:%f\noffStart:%f\n父类view宽总和:%f\n=======================",(unsigned long)[viewArray count], width_allSubV, offStart, offEnd, parentScrollView.contentSize.width);
        }
    }else{
        
        /*
         垂直方向自动布局
         */
        //获取所有子类view的高度总和
        for (UIView *tempSubView in viewArray) {
            width_allSubV += tempSubView.frame.size.height;
        }
        
        if (parentScrollView.contentSize.height - width_allSubV >= offStart + offEnd) {
            /*
             可以使用高度自动布局
             */
            CGFloat deltaX = (parentScrollView.contentSize.height - width_allSubV - offStart - offEnd)/([viewArray count] + k);//子view的x间距
            CGFloat tempX = offStart;//用于存储子view临时的X起点
            if (offDistanceEqualViewDistance) {
                tempX = deltaX;
            }
            for (int i = 0; i < [viewArray count]; i++) {
                UIView *tempSubView = viewArray[i];
                
                //给子view重新设定x起点
                CGRect tempFrame = tempSubView.frame;
                tempFrame.origin.y = tempX;
                tempSubView.frame = tempFrame;
                
                if (centerEqualParent) {
                    //竖直方向相对于父类view剧中
                    tempSubView.center = CGPointMake(parentScrollView.contentSize.width/2, tempSubView.center.y);
                }
                //tempX加上当前子view的width和deltaX
                tempX = tempX + CGRectGetHeight(tempSubView.bounds) + deltaX;
            }
        }else{
            
            /*
             无法使用自动布局
             */
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view高总和:%d\noffStart:%f\noffStart:%f\n父类view高总和:%f\n=======================",(unsigned long)[viewArray count], width_allSubV, offStart, offEnd, parentScrollView.contentSize.height);
        }
    }
}

#pragma mark Bear根据子view自动布局
/*
 改进通知：
 1.增加是否自动添加到父类view功能
 2.集成到扩展类中
 3.增加至根据子类view间距自动布局功能
 */

/*
 viewArray:         装有子类view的数组
 parentView:        父类的view
 offStart:          起始点和边框的距离
 offEnd:            结束点和边框的距离
 centerEqualParent: 是否和父类的view剧中对其（YES：剧中对其，NO：不剧中对齐）
 horizontalOrNot:   是否水平自动布局（YES：水平方向自动布局，NO：垂直方向自动布局）
 offDistanceEqualViewDistance 边距和view之间的距离是否相等
 */
+ (void)BearHorizontalAutoLay:(NSMutableArray *)viewArray parentView:(UIView *)parentView offStart:(CGFloat)offStart offEnd:(CGFloat)offEnd centerEqualParent:(BOOL)centerEqualParent horizontalOrNot:(BOOL)horizontalOrNot offDistanceEqualViewDistance:(BOOL)offDistanceEqualViewDistance
{
    int width_allSubV = 0;  //所有子view的宽总和
    int k = -1;             //设置边距距离是否和view的间距相等
    if (offDistanceEqualViewDistance) {
        k = 1;
    }
    
    if (horizontalOrNot) {
        
        /*
         水平方向自动布局
         */
        //获取所有子类view的宽度总和
        for (UIView *tempSubView in viewArray) {
            width_allSubV += tempSubView.frame.size.width;
        }
        
        if (CGRectGetWidth(parentView.bounds) - width_allSubV >= offStart + offEnd) {
            /*
             可以使用宽度自动布局
             */
            
            CGFloat deltaX = (CGRectGetWidth(parentView.bounds) - width_allSubV - offStart - offEnd)/([viewArray count] + k);//子view的x间距
            CGFloat tempX = offStart;//用于存储子view临时的X起点
            if (offDistanceEqualViewDistance) {
                tempX = deltaX;
            }
            for (int i = 0; i < [viewArray count]; i++) {
                UIView *tempSubView = viewArray[i];
                
                //给子view重新设定x起点
                CGRect tempFrame = tempSubView.frame;
                tempFrame.origin.x = tempX;
                tempSubView.frame = tempFrame;
                
                if (centerEqualParent) {
                    //竖直方向相对于父类view剧中
                    tempSubView.center = CGPointMake(tempSubView.center.x, CGRectGetHeight(parentView.bounds)/2);
                }
                //tempX加上当前子view的width和deltaX
                tempX = tempX + CGRectGetWidth(tempSubView.bounds) + deltaX;
            }
        }else{
            
            /*
             无法使用自动布局
             */
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view宽总和:%d\noffStart:%f\noffStart:%f\n父类view宽总和:%f\n=======================",(unsigned long)[viewArray count], width_allSubV, offStart, offEnd, CGRectGetWidth(parentView.bounds));
        }
    }else{
        
        /*
         垂直方向自动布局
         */
        //获取所有子类view的高度总和
        for (UIView *tempSubView in viewArray) {
            width_allSubV += tempSubView.frame.size.height;
        }
        
        if (CGRectGetHeight(parentView.bounds) - width_allSubV >= offStart + offEnd) {
            /*
             可以使用高度自动布局
             */
            CGFloat deltaX = (CGRectGetHeight(parentView.bounds) - width_allSubV - offStart - offEnd)/([viewArray count] + k);//子view的x间距
            CGFloat tempX = offStart;//用于存储子view临时的X起点
            if (offDistanceEqualViewDistance) {
                tempX = deltaX;
            }
            for (int i = 0; i < [viewArray count]; i++) {
                UIView *tempSubView = viewArray[i];
                
                //给子view重新设定x起点
                CGRect tempFrame = tempSubView.frame;
                tempFrame.origin.y = tempX;
                tempSubView.frame = tempFrame;
                
                if (centerEqualParent) {
                    //竖直方向相对于父类view剧中
                    tempSubView.center = CGPointMake(CGRectGetWidth(parentView.bounds)/2, tempSubView.center.y);
                }
                //tempX加上当前子view的width和deltaX
                tempX = tempX + CGRectGetHeight(tempSubView.bounds) + deltaX;
            }
        }else{
            
            /*
             无法使用自动布局
             */
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view高总和:%d\noffStart:%f\noffStart:%f\n父类view高总和:%f\n=======================",(unsigned long)[viewArray count], width_allSubV, offStart, offEnd, CGRectGetHeight(parentView.bounds));
        }
    }
}

@end
