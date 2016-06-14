//
//  PublicTool.m
//  Voiceprint
//
//  Created by huangrg on 14-10-15.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//
#import "PublicFunc.h"
#include <sys/sysctl.h>
#include <mach/mach.h>

@implementation PublicFunc
static PublicFunc* _share_instance = nil;
+(PublicFunc*)getInstance
{
    if (!_share_instance)
    {
        _share_instance = [[PublicFunc alloc] init];
    }
	return _share_instance;
}

-(id)init
{
	if(!(self = [super init]))
		return nil;
    
    //格式化时间 时间类型数组
    
    dayStr = [NSArray arrayWithObjects:
               NSLocalizedString(@"天",nil),
               NSLocalizedString(@"小时",nil),
               NSLocalizedString(@"分",nil),
               NSLocalizedString(@"秒",nil),
               nil];
    
    dayDHMS = [[NSArray alloc] initWithObjects:@"d",@"h",@"m",@"s",nil];
    
    //    flsg[0] = INT32_MAX;
    flsg[0] = 86400;
    flsg[1] = 3600;
    flsg[2] = 60;
    flsg[3] = 1;
    
    
    return self;
}

//返回size的中心点
CGPoint uiFromSize(CGSize s)
{
	return CGPointMake(s.width, s.height);
}
//以A点的基准,按B点的比率返回一个新点
CGPoint uiCompMult(CGPoint a, CGPoint b)
{
	return CGPointMake(a.x * b.x, a.y * b.y);
}
//时间转换为天/时/分/秒中的 digit 个 ,优先级从“天”依次降低
-(NSString *)convertTimeOfDHMS:(int) secs digit:(int)digit
{
    NSAssert(digit>=0, @"digit <= 0");
    
    NSMutableString *timeFormat = [NSMutableString stringWithFormat:@""];
    
    secs = abs(secs);
    BOOL isBegan = NO;  //取第一个不为零的数后设为YES
    
    for(int i=0;i<4;i++)
    {
        if(digit <=0 ) break ;
        int tempNum = secs/ flsg[i];
        secs = secs%flsg[i];
        if(isBegan || tempNum > 0)
        {   isBegan = YES;
            [timeFormat appendFormat:@"%d%@",tempNum,[dayStr objectAtIndex:i]];
            digit--;
        }
    }
    if(!isBegan)
        [timeFormat appendFormat:@"%d%@",0,[dayStr objectAtIndex:3]];
    
	return timeFormat;
}

//判断是否是iphone5
-(BOOL)isIPhone5RetinaDisplay
{
    return ([[UIScreen mainScreen] bounds].size.height == 568);
}

//数字加分隔符
-(NSString *)setTTFWithNum:(double)num
{
    NSNumberFormatter* numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormat setPositiveFormat:@"###,##0.00;"];
    return [numFormat stringFromNumber:[NSNumber numberWithDouble:num]];
}

//UIImage 图片处理 灰度 反色 深棕色
-(UIImage*) grayscale:(UIImage*)anImage type:(char)type
{
    CGImageRef  imageRef;
    imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // ピクセルを構成するRGB各要素が何ビットで構成されている
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    // ピクセル全体は何ビットで構成されているか
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    // 画像の横1ライン分のデータが、何バイトで構成されているか
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    // 画像の色空間
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    // 画像のBitmap情報
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // 画像がピクセル間の補完をしているか
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    // 表示装置によって補正をしているか
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    // 画像のデータプロバイダを取得する
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダから画像のbitmap生データ取得
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    // 1ピクセルずつ画像を処理
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4; // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
            
            // RGB値を取得
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            
            switch (type) {
                case 1://モノクロ
                    // 輝度計算
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                    
                case 2://セピア
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                    
                case 3://色反転
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                    
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
            
        }
    }
    
    // 効果を与えたデータ生成
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}

//根据两个经纬度计算距离
#define PI 3.1415926
-(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2
{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}


#pragma mark - 关于时区
//转化任意日期到当前时区
-(NSDate *)convertDateToLocalTime: (NSDate *)forDate
{
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];
    return newDate;
}
//日期转时间时间戳
-(NSString *)convertDataToInterval:(NSDate *)date
{
    NSTimeInterval aInterval =[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", aInterval];
    return timeString;
}
//时间戳转为时间格式的字符串
-(NSString *)sectionStrByCreateTime:(NSTimeInterval)interval Format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *_data = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:_data];
}
//把字符串转换成NSDate
-(NSDate *)NSStringDateToNSDate:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* date = [formatter dateFromString:string];
    return date;
}

//获取本时区时间
-(NSDate *)localeDateTime
{
    NSDate * seldate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: seldate];
    NSDate * date = [seldate dateByAddingTimeInterval: interval];
    return date;
}

//检测用户名格式
-(BOOL)bLoginName:(NSString*)str
{
    //匹配任何字母（a到z以及A到Z）和任何数字（0到9），以及_ （下划线）字符,6-20个字符
    NSString *loginNameRegex = @"^[a-zA-Z0-9_]{6,20}$";
    
    NSPredicate *loginNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginNameRegex];
    
    return [loginNameTest evaluateWithObject:str];
    
}

//检测用户名长度
-(BOOL)bNameLength:(NSString*)str
{
    if ([str length] > 20 || [str length] < 6 ) { //如果输入框内容为6－20个字符，则返回YES
        return NO;
    }
    return YES;
}

//检测密码格式
-(BOOL)bPassWord:(NSString*)str
{
    //匹配任何字母（a到z以及A到Z）和任何数字（0到9），以及_ （下划线）字符,6-20个字符
    NSString *passWordRegex = @"^[a-zA-Z0-9_-]{6,20}$";
    
    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    
    return [passWordTest evaluateWithObject:str];
}
//检测邮箱地址格式
-(BOOL)isEmailAddress:(NSString*)email
{
    
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//身份证号格式
- (BOOL) isIdCard: (NSString *)identityCard
{
    if (identityCard.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
    
    
}
//验证码加空格（声密保）
- (NSString *) codeAddSpace: (NSString *)code
{
    NSString *str1 = [code substringToIndex:4];
    NSString *str2 = [code substringFromIndex:4];
    NSString *str = [NSString stringWithFormat:@"%@  %@",str1,str2];
    return str;
}

//手机号加*
- (NSString *) mobileAddStar: (NSString *)mobile
{
    NSString *str1 = [mobile substringToIndex:3];
    NSString *str2 = [mobile substringFromIndex:8];
    if([str1 isEqualToString:nil])
    {
        str1 = @"";
    }
    if([str2 isEqualToString:nil])
    {
        str2 = @"";
    }
    NSString *str = [NSString stringWithFormat:@"%@*****%@",str1,str2];
    return str;
}

//身份证号加*
- (NSString *) identityCardAddStar: (NSString *)identityCard
{
    NSString *str1 = [identityCard substringToIndex:4];
    NSString *str2 = [identityCard substringFromIndex:([identityCard length]-4)];
    NSString *str = [NSString stringWithFormat:@"%@*****%@",str1,str2];
    return str;
}

#pragma mark -  程序目录及路径操作
//获取程序的Home目录
-(NSString *)getHomePath
{
    NSString  *path = NSHomeDirectory();
    return path;
}
//获取Document目录
-(NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

//获取Cache目录
-(NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    //    NSString *cacheDirectory = [path stringByAppendingPathComponent:@"huangrg"];
    return path;
}

//返回缓存文件夹大小
-(unsigned long long int)cacheFolderSize
{
    NSFileManager  *_manager = [NSFileManager defaultManager];
    NSString  *_cacheDirectory = @"";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    if (0 < [cachesPath length])
    {
        _cacheDirectory = [cachesPath stringByAppendingPathComponent:@"huangrg_Cache"];
    }
    
    NSArray  *_cacheFileList;
    NSEnumerator *_cacheEnumerator;
    NSString *_cacheFilePath;
    unsigned long long int _cacheFolderSize = 0;
    _cacheFileList = [ _manager subpathsAtPath:_cacheDirectory];
    _cacheEnumerator = [_cacheFileList objectEnumerator];
    while (_cacheFilePath = [_cacheEnumerator nextObject])
    {
        NSDictionary *_cacheFileAttributes =[_manager attributesOfItemAtPath:[_cacheDirectory  stringByAppendingPathComponent:_cacheFilePath]error:nil];
        
        _cacheFolderSize += [_cacheFileAttributes fileSize];
        
    }
    // 单位是字节
    return _cacheFolderSize;
}

//清空缓存
-(void)resetCache
{
    NSString  *_cacheDirectory = @"";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    if (0 < [cachesPath length])
    {
        _cacheDirectory = [cachesPath stringByAppendingPathComponent:@"huangrg_Cache"];
    }
    
    BOOL existFile = [[NSFileManager defaultManager] fileExistsAtPath:_cacheDirectory];
    NSError* err;
    if (existFile)
    {
        [[NSFileManager defaultManager] removeItemAtPath:_cacheDirectory error:&err];
    }
}

//获取Library目录
-(NSString *)getLibraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *path = [paths objectAtIndex:0];
    return path;
}
//获取Tmp目录
-(NSString *)getTmpPath
{
    NSString *path = NSTemporaryDirectory();
    return path;
}

#pragma mark - 判断密码强度函数

//判断是否包含

+(BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password

{
    NSRange range;
    BOOL result = NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    
    return result;
    
}

//条件
+ (int) judgePasswordStrength:(NSString*) _password

{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@" ", nil];
    
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    
    
    int Result=0;
    
    for (int j=0; j<[resultArray count]; j++)
        
    {
        
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
            
        {
            Result++;
            
        }
        
    }
    
    if([result4 isEqualToString:@"1"])
    {
        Result = 4;//含有空格
    }
    
    return Result;
    
}

#pragma mark -  浏览器缓存
//清除cookies
-(void)deleteUIWebViewCookie
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}
//UIWebView清除缓存
-(void)deleteUIWebViewCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark -  随机生成字符串
//生成随机数
-(int)createRandom
{
    srand((unsigned int)(time(NULL)));
    unsigned int a = rand();
    return a;
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - 图片

//保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withPath:(NSString *)path
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 将图片写入文件
    [imageData writeToFile:path atomically:NO];
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - 二维码生成
#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

#pragma mark -
-(NSString *)getUrlParameter:(NSString *)param webaddress:(NSString *)url
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches)
    {
        
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];
        return tagValue;
    }
    return @"";
}

@end
