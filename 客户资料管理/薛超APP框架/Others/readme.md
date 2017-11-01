## 前言
本框架是由薛超为期一周时间设计的用于iOS_APP开发的框架，分类清晰，设计巧妙，封装性好。如果在使用中遇到什么问题可以及时修改优化本框架。
熟练使用本框架的人基本掌握了以下开发能力:
* 1、掌握C/Objective-C /CocoaTouch编程，对Swift略有涉猎。
* 2、熟悉各种UI控件，熟悉多视图开发，能够实现复杂的界面交互以及应用间通讯。
* 3、熟练使用MacOS、Xcode、iOS_SDK、framework及xib和storyboard与autoLayout等开发工具。
* 4、熟练使用UIView、CoreAnimation、ImageView等动画和各种手势及特效优化APP产品。
* 5、熟悉MVC、委托代理、单例、工厂方法和观察者模式等常用设计模式。
* 6、熟练使用NSURLSession、 AFNetworking进行网络数据请求。
* 7、熟练使用AFNetworking、MBProgressHUD、MJRefresh、SDWebImage等三方库。
* 8、熟练掌握GCD、NSOperation、NSThread多线程编程技术。
* 9、熟悉NSUserDefault、Plist和Json等数据持久化技术及网络数据的解析。
* 10、了解地图定位、定制大头针、搜索、导航、地理编码与反编码等功能。
* 11、高新技术：二维码、摇一摇、蓝牙技术、发短信打电话发邮件、应用间切换、本地通知。

##简介
薛超APP框架是集合了以下功能系列：
1.是主流的APP框架，四个tabBar，分别为首页、服务、发现、我的。
2.启动从storyboard和APPDelegate启动，首先会启动utility/BaseFile/HomeTabBarController，该类调用自定义的HomeTabBar和HomeNavigationController。
3.初始设置绑定storyboard对应的TabBarcontroller和NavigationController并做相应的配置。
4.启动自带Coredata数据库处理功能，使用github源代码管理工具Cocoapods导入第三方库。
5.Utility类封装了有关登录注册 userDefaults 时间戳 数据格式化 定位 振动与抖动提醒 视图与界面 元件创建  蓝牙 语音识别 支付 分享 即时聊天 打电话以及版本更新等功能。
6.Foundation用于封装系统中常用的简单方法，Foundation_API用于封装系统要用到的所有外界接口连接，Foundation_defines用于封装第三方平台需要注册的内容（如支付宝、微信、百度等）。
7.category文件夹聚集了常用的系统类的功能扩展，让开发更加随意简便。
8.BaseFile文件夹封装了最为常用的类，继承之可以急速创建好相应的功能和界面。如UIViewController,UITableView,UIScrollVie,UICollectionView。
9.尽量所有界面控制器都继承BaseViewController 其封装的TableView和CollectionView以及界面跳转之间的传值等功能很好用。
10.another文件夹中放有常用到的注册、登录和找回密码的功能与界面。
11.Others/language文件是大字典用于匹配APP的中英文，只需要用宏定义一个方法就可以自由切换中英文状态。
12.系统采用逻辑性文件夹管理模式，四个主功能分别存放四个文件夹，ThirdSDK存放无法通过cocoapods自动导入的第三方库，如微信SDK，支付宝SDK，百度SDK等。
13.Others文件夹存放平时少用到的系统文件，如Coredata，AppDelegate，PrefixHeader，main，info，readme等。
14.utility存放开发过程中经常用到的方法，分别封装在对应的类之中。
15.resource和Assets用于存放开发中要用到的本地文件，如图片、plist、txt等。框架采用cocoapods，详情可见Podfile，详细记录使用了那些三方库，它们的功能及网址。

##更新记录
* 1、使用Cocoapods建立了整个APP系统层，包括网络请求框架，图片缓存框架，JSON与对象，友盟分享，SharedSDK，提示性信息，数据库，即时聊天，特效以及其他系列功能架构。                 2016.09.01
* 2、建立了整个APP辅助层，包括各个系统类功能的扩展、分类和继承以及基本类，如BaseViewController，categorys,手动导入的三方库。                                              2016.09.02
* 3、完善了APP整个框架的基本配置，如info.plist,PrefixHeader,Foundation,README记录,封装了工具类Utility，导入了应用中可能用到的系列库(Linked Frameworks and Libraries)。  2016.09.03
* 4、建立了Coredata使用框架以及Database使用框架，应用中将充分利用Coredata，Database，Sqlite，Plist，Archive,本地文件(如TXT)读取结合网络请求与JSON解析处理数据。            2016.09.04
* 5、建立了APP整个框架结构的文件夹，有效分类了所有功能系列，并建立了所有功能应用的基础框架，如各自的Storyboard，TabBarViewController，ViewController。                      2016.09.05
* 6、建立了基本的数据库系列，如icons.txt  TotalData  UserData.plist  MyCoreData.xcdatamodeld  Coredata.json                                                     2016.09.06
* 7、引入了APP整个系列功能要用到的通用图片。                                                                                                                      2016.09.07
* 8、修复了已知bug和冲突，如MRC与ARC，Objective和Swift，配置了APPICON，LaunchScreen，真机测试运行成功。                                                              2016.09.08

##未完成的功能
* 1、微信支付
* 2、支付宝支付
* 3、第三方登录与分享
* 4、即时聊天
* 5、蓝牙
* 6、远程推送

##个人简介
1.	本人酷爱互联网行业的软件开发工作，做事积极负责，有很强的内驱力。
2.	基础扎实，思路清晰，有良好的编程习惯，结构清晰，命名规范，逻辑性强，代码冗余率低。
3.	具有较强需求分析、逻辑思维、程序设计、技术钻研精神。
4.	另外心思缜密，创新意识，文档写作，组织协调沟通与表达以及团队合作的能力。
5.	自学能力强，勇于面对和克服困难，能承受较大的工作压力。

##复杂功能说明
内含excel文件解析读取，依赖库：libiconv.tbd需要加入新的xcodeproj，增加方法如下：
1. 将开源项目拖入项目文件夹中，点击file/AddFilesTo  选择开源项目的.xcodeproj
2. Build Phases下 Links Binary With Libraries 引入.a文件。Target Dependencies里引入.a文件
3. Build Setting下的 Search Paths 里 Header Search Paths 加入开源项目src目录
如果该excel解析库文件夹libxls为空，则可以在终端进入该文件夹下svn co https://libxls.svn.sourceforge.net/svnroot/libxls/trunk/libxls libxls
*2.内含把数据写成xls文件并分享和发送邮件的方法。
1.设置bitcode为no,other linker flag为-lstdc++
2.下载LibXL.framework拖进项目即可http://www.libxl.com/download.html

