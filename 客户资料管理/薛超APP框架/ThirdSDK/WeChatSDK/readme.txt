Demo˵����
Ҫ����:Security.framework  CoreTelephony.framework  SystemConfiguration.framework  libz.dylib  libsqlite3.0.dylib  UIKit.framework  Foundation.framework  
��Target/info/URL Types��������weixin identifier��weixin  URLSechemes��wexb4a3c02aa476ea1
��info.plist����URLTypes   LSApplicationQueriersSchemes��weixin
ע�⣺
	1.��Demoֻ����һ���������ʾ,����֧��������;
	2.�µ���ǩ�����鵥��֧��֪ͨ���ڷ�������̨ʵ�֣���ο���̨SDK���롣
	3.��Demo��64λ��SDK
	4.ֱ�����п�����
	5.API�����https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=8_1

�������裺
	1.����΢��APP֧������Ҫ��ȥ΢�ſ���ƽ̨�����ƶ�Ӧ�ã�����ͨ΢��֧�����ܣ�ͨ����˺󷽿ɽ��п�����
	2.��XCode����Ŀ������Ŀ���ԡ�-��Info��-��URL Schemes������΢�ſ���ƽ̨�����Ӧ��APPID����ͼ�ļ�����"����appid.jpg"��ʾ��������APPID���ò���ȷ���޷�����΢��֧����
	3.��Ҫ���ô���ע��APPID��[WXApi registerApp:APP_ID withDescription:@"demo 2.0��];��Ŀ��APPID���벽��2��APPID����һ�£�
	4.֧������WXApiRequestHandler.m�е�jumpToBizPay����ʵ���˻���΢��֧����
	5.֧����ɻص���WXApiManager.m�е�onResp�����н��շ���֧��״̬��
APPDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[SendMsgToWeChatViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[SendMsgToWeChatViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //��΢��ע��wxd930ea5d5a258f4f
    [WXApi registerApp:@"wxb4ba3c02aa476ea1" withDescription:@"demo 2.0"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

