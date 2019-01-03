//
//  BearCutDownBtn.h
//

#import <UIKit/UIKit.h>
@class BearCutDownBtn;

@protocol BearCutDownBtnDelegate <NSObject>

- (void)cutDownBtnTitleHasChanged:(BearCutDownBtn *)cutdown;

@end

@interface BearCutDownBtn : UIButton

@property (weak, nonatomic) id <BearCutDownBtnDelegate> delegate;
@property (strong, nonatomic) NSString *btnStringNormal;
@property (strong, nonatomic) NSString *btnStringUnEnable;
@property (strong, nonatomic) NSString *btnStringRetry;
@property (assign, nonatomic) NSTimeInterval totalSecond;

- (void)startCutDown;

@end
