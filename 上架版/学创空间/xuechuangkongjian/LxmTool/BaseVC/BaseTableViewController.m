//
//  BaseTableViewController.m
//  ShareGo
//
//  Created by 李晓满 on 16/4/7.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import <UMShare/UMShare.h>

@interface BaseTableViewController ()
{
    UITableViewStyle _tableViewStyle;
}
@end
@implementation BaseTableViewController
-(instancetype)initWithTableViewStyle:(UITableViewStyle)style
{
    if (self=[super init])
    {
        _tableViewStyle = style;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseTableView];
}
-(void)initBaseTableView
{
    _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    _tableView.autoresizingMask  =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

//- (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    [filter setDefaults];
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    [filter setValue:data forKey:@"inputMessage"];
//    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
//    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
//    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
//}
//
//- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
//    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
//    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
//    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
//    UIImage *waterimage = [UIImage lzbImageNamed:@"ic_forqrcode"];
//    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
//    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newPic;
//}



- (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

- (void)shareWeChatTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock{
   
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.title = title?title:@"";
    messageObject.text = content?content:@"";
    //创建图片内容对象
    NSString *urlKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:pic]];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlKey];
    if (!image) {
        image = [UIImage imageNamed:@"1024"];
    }
    UMShareWebpageObject * obj = [UMShareWebpageObject shareObjectWithTitle:messageObject.title descr:messageObject.text thumImage:image];
    obj.webpageUrl = url;
    messageObject.shareObject = obj;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            if (errorBlock) {
                errorBlock();
            }
        }else{
            if (okBlock) {
                okBlock();
            }
        }
    }];
    
}
- (void)shareWXPYQTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.title = title?title:@"";
    messageObject.text = content?content:@"";
    //创建图片内容对象
    NSString *urlKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:pic]];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlKey];
    if (!image) {
        image = [UIImage imageNamed:@"1024"];
    }
    UMShareWebpageObject * obj = [UMShareWebpageObject shareObjectWithTitle:messageObject.title descr:messageObject.text thumImage:image];
    obj.webpageUrl = url;
    messageObject.shareObject = obj;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (errorBlock) {
                errorBlock();
            }
        }else{
            if (okBlock) {
                okBlock();
            }
        }
    }];
    
    
}
- (void)shareZFBTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString*)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock{

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.title = title?title:@"";
    messageObject.text = content?content:@"";
    //创建图片内容对象
    NSString *urlKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:pic]];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlKey];
    if (!image) {
        image = [UIImage imageNamed:@"1024"];
    }
    UMShareWebpageObject * obj = [UMShareWebpageObject shareObjectWithTitle:messageObject.title descr:messageObject.text thumImage:image];
    obj.webpageUrl = url;
    messageObject.shareObject = obj;
    
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_AlipaySession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (errorBlock) {
                errorBlock();
            }
        }else{
            if (okBlock) {
                okBlock();
            }
        }
    }];
}

- (void)shareQQTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.title = title?title:@"";
    messageObject.text = content?content:@"";
    //创建图片内容对象
    NSString *urlKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:pic]];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlKey];
    if (!image) {
        image = [UIImage imageNamed:@"1024"];
    }
    UMShareWebpageObject * obj = [UMShareWebpageObject shareObjectWithTitle:messageObject.title descr:messageObject.text thumImage:image];
    obj.webpageUrl = url;
    messageObject.shareObject = obj;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (errorBlock) {
                errorBlock();
            }
        }else{
            if (okBlock) {
                okBlock();
            }
        }
    }];
}

@end
