//
//  UIImage+Extension.m
//  图片拉伸
//
//  Created by chenlishuang on 16/10/21.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+(UIImage *)resizebleImageNamed:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
}
@end
