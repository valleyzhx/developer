//
//  ZXUnitil.m
//  auto-jd
//
//  Created by Xiang on 15/4/27.
//  Copyright (c) 2015年 lsx. All rights reserved.
//

#import "ZXUnitil.h"
#import "MyDefines.h"
#import <QuartzCore/QuartzCore.h>


@implementation ZXUnitil

static void (^myFinished)();
static ZXUnitil *_unitil;
+(BOOL)isIPAddress:(NSString *)ipString{
    //000.000.0.0
    NSString *ip = @"^((25[0-5]|2[0-4]\\d|[01]?\\d\\d?)($|(?!\\.$)\\.)){4}$";
    NSPredicate *regextestip = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ip];
    if ([regextestip evaluateWithObject:ipString] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
//身份证号
+ (BOOL) isIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134、135、136、137、138、139、150、151、152、157、158、159、182、183、184、187、188、178(4G)
     * 联通：130、131、132、155、156、185、186、176(4G)
     * 电信：133、153、180、181、189 、177(4G)
     * 虚拟运营商：170
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(void)fitTheLabel:(UILabel *)label{
    float height = [self heightOfStringWithString:label.text font:label.font width:label.frame.size.width];
    CGRect rect = label.frame;
    rect.size.height = height;
    label.frame = rect;
}

+ (float)heightOfStringWithString:(NSString *)str font:(UIFont *)font width:(float)width{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height+1;
}
+ (BOOL)version:(NSString *)oldver lessthan:(NSString *)newver
{
    return [oldver compare:newver options:NSNumericSearch] == NSOrderedAscending;
}


+(UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
+(NSString *)abNameWithProvince:(NSString *)province{
    //京沪浙苏粤鲁晋冀豫川渝辽吉黑皖鄂湘赣闽陕甘宁蒙津贵云桂琼青新藏
    if([province isEqualToString: @"北京"])
        return @"京";
    else if([province isEqualToString:@"天津"])
        return @"津";
    else if([province isEqualToString:@"重庆"])
        return @"渝";
    else if([province isEqualToString:@"上海"])
        return @"沪";
    else if([province isEqualToString:@"河北"])
        return @"冀";
    else if([province isEqualToString:@"山西"])
        return @"晋";
    else if([province isEqualToString:@"辽宁"])
        return @"辽";
    else if([province isEqualToString:@"吉林"])
        return @"吉";
    else if([province isEqualToString:@"黑龙江"])
        return @"黑";
    else if([province isEqualToString:@"江苏"])
        return @"苏";
    else if([province isEqualToString:@"浙江"])
        return @"浙";
    else if([province isEqualToString:@"安徽"])
        return @"皖";
    else if([province isEqualToString:@"福建"])
        return @"闽";
    else if([province isEqualToString:@"江西"])
        return @"赣";
    else if([province isEqualToString:@"山东"])
        return @"鲁";
    else if([province isEqualToString:@"河南"])
        return @"豫";
    else if([province isEqualToString:@"湖北"])
        return @"鄂";
    else if([province isEqualToString:@"湖南"])
        return @"湘";
    else if([province isEqualToString:@"广东"])
        return @"粤";
    else if([province isEqualToString:@"海南"])
        return @"琼";
    else if([province isEqualToString:@"四川"])
        return @"川";
    else if([province isEqualToString:@"贵州"])
        return @"贵";
    else if([province isEqualToString:@"云南"])
        return @"云";
    else if([province isEqualToString:@"陕西"])
        return @"陕";
    else if([province isEqualToString:@"甘肃"])
        return @"甘";
    else if([province isEqualToString:@"青海"])
        return @"青";
    else if([province isEqualToString:@"台湾"])
        return @"台";
    else if([province isEqualToString:@"内蒙古"])
        return @"蒙";
    else if([province isEqualToString:@"广西"])
        return @"桂";
    else if([province isEqualToString:@"宁夏"])
        return @"宁";
    else if([province isEqualToString:@"新疆"])
        return @"新";
    else if([province isEqualToString:@"西藏"])
        return @"藏";
    else if([province isEqualToString:@"香港"])
        return @"港";
    else if([province isEqualToString:@"澳门"])
        return @"澳";
    return @"";
}

+(NSString *)halfWithStringFromFullString:(NSString *)string{
    NSMutableString *convertedString = [string mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformFullwidthHalfwidth, false);
    return convertedString;
}


+(NSDictionary *)urlQueryDicWithQueryString:(NSString *)query{
    __block NSMutableDictionary *dic = nil;
    if (query) {
        dic = [NSMutableDictionary dictionary];
        NSArray *itemArr = [query componentsSeparatedByString:@"&"];
        [itemArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *itemStr = obj;
            NSArray *kvArr = [itemStr componentsSeparatedByString:@"="];
            if (kvArr.count>1) {
                [dic setValue:kvArr[1] forKey:kvArr[0]];
            }
        }];
        
    }
    return dic;
}


+(void)startAnimation:(UIView *)view delay:(float)delay finised:(void (^)())finishedBlock{
    myFinished = finishedBlock;
    if (_unitil == nil) {
        _unitil = [[ZXUnitil alloc]init];
    }
    view.transform = CGAffineTransformMakeScale(0.85, 0.85);
    NSString *str = [NSString stringWithFormat:@"ID-%.2f",delay];
    NSLog(@"----%@",str);
    [UIView beginAnimations:str context:nil];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:_unitil];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:1.5];
    view.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    if ([animationID isEqualToString:@"ID-0.46"])
    {
        if (myFinished) {
            myFinished();
        }
        myFinished = nil;
    }
}

-(void)dealloc{
    myFinished = nil;
}

@end


@implementation UIView (virtualLine)

-(void)addVirLineWithColor:(UIColor *)color{
    NSArray *array = self.layer.sublayers;
    CALayer *lastLayer = [array lastObject];
    if ([lastLayer isKindOfClass:[CAShapeLayer class]]) {
        CAShapeLayer *shapeLayer = (CAShapeLayer*)lastLayer;
        [shapeLayer setStrokeColor:color.CGColor];
    }else{
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:self.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        // 设置虚线颜色为blackColor [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
        [shapeLayer setStrokeColor:color.CGColor];
        [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        // 3=线的宽度 1=每条线的间距 [shapeLayer setLineDashPattern:
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5],
                                        [NSNumber numberWithInt:2],nil]];
        
        // [shapeLayer setPath:path];
        shapeLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        shapeLayer.frame = self.bounds;
        [self.layer addSublayer:shapeLayer];
    }
    
    
    
    
}
-(void)changeVirLineColor:(UIColor *)color{
    NSArray *array = self.layer.sublayers;
    CALayer *lastLayer = [array lastObject];
    if ([lastLayer isKindOfClass:[CAShapeLayer class]]) {
        CAShapeLayer *shapeLayer = (CAShapeLayer*)lastLayer;
        [shapeLayer setStrokeColor:color.CGColor];
    }
}
@end


@implementation UITableView (HiddenExtraCellLine)

-(void)setHiddenExtrLine:(BOOL)shouldHidden{
    if (shouldHidden) {
        UIView *view =[ [UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [self setTableFooterView:view];
    }
}

@end

@implementation NSString (json)

-(id)jsonObject{
   id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    return object;
}

@end

@implementation NSData (json)

-(id)jsonObject{
    id object = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
    return object;
}

@end


@implementation NSObject (json)
-(NSString*)jsonString{
    if ([NSJSONSerialization isValidJSONObject:self]) {
       NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return str;
    }
    return nil;
}

@end




