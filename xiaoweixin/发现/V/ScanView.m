//
//  ScnaView.m
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/11.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "ScanView.h"
static NSTimeInterval kQrLineanimateDuration = 0.01;

@interface ScanView()
/** 透明的区域 */
@property (nonatomic, assign) CGSize transparentArea;
/** 扫描横线*/
@property (nonatomic,strong)UIImageView *qrLineImageView;
/** 说明文字*/
@property (nonatomic,strong)UILabel *tipLabel;
/** 扫描线的高度*/
@property (nonatomic,assign)CGFloat qrLineY;
@end
@implementation ScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tipLabel = [[UILabel alloc]init];
        self.tipLabel.text = @"将二维码放入矩形框内,即可自动扫描";
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.font = [UIFont systemFontOfSize:11];
        [self.tipLabel sizeToFit];
        [self addSubview:self.tipLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.qrLineImageView) {
        self.transparentArea = CGSizeMake(200, 200);
        [self initQRLine];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kQrLineanimateDuration target:self selector:@selector(show) userInfo:nil repeats:YES];
        [timer fire];
    }
    self.tipLabel.center = CGPointMake(self.bounds.size.width * 0.5, CGRectGetMaxY([self clearDrawRect])+40);
    
}

- (void)initQRLine{
    self.qrLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - self.transparentArea.width/2, ScreenHeight/2 - self.transparentArea.height/2, self.transparentArea.width, 8)];
    self.qrLineImageView.image = [UIImage imageNamed:@"QRCodeScanLine"];
    self.qrLineImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.qrLineImageView];
    self.qrLineY = self.qrLineImageView.frame.origin.y;
}

- (CGRect)clearDrawRect{
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(ScreenWidth/2 - self.transparentArea.width/2, ScreenHeight/2 - self.transparentArea.height/2, self.transparentArea.width, self.transparentArea.width);
    return clearDrawRect;
    
}

- (void)show{
    
    [UIView animateWithDuration:kQrLineanimateDuration animations:^{
        CGRect rect = self.qrLineImageView.frame;
        rect.origin.y = self.qrLineY;
        self.qrLineImageView.frame = rect;
    }completion:^(BOOL finished) {
        CGFloat maxBorder = self.frame.size.height / 2 + self.transparentArea.height / 2 - 4;
        if (self.qrLineY > maxBorder) {
            self.qrLineY = self.frame.size.height / 2 - self.transparentArea.height /2;
        }
        self.qrLineY ++;
    }];
}

- (void)drawRect:(CGRect)rect{
    //整个二维码扫描界面的颜色
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
                                      self.transparentArea.width,self.transparentArea.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
    
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}


@end
