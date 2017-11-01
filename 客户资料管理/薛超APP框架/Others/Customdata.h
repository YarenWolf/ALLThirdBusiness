//
//  Customdata+CoreDataClass.h
//  Created by 薛超 on 16/10/31.
#import <CoreData/CoreData.h>
@interface Customdata : NSManagedObject
@property (nonatomic, retain) NSString *tname;        //投保人姓名
@property (nonatomic, retain) NSString *tid;        //投保人保单号
@property (nonatomic, retain) NSString *tbaoe;//显示的保额
@property (nonatomic, retain) NSString *tbirthday; //出生年月
@property (nonatomic, retain) NSString *tsex; //性别
@property (nonatomic, retain) NSString *tIDnumber; //身份证号
@property (nonatomic, retain) NSString *tdayphone; //投保人日间电话
@property (nonatomic, retain) NSString *tnightphone; //投保人夜间电话
@property (nonatomic, retain) NSString *ttelephone; //投保人手机
@property (nonatomic, retain) NSString *tacceptM; //投保人短信接收
@property (nonatomic, retain) NSString *tworknumber; //投保人职业代码
@property (nonatomic, retain) NSString *tEmail; //客户电子邮箱
@property (nonatomic, retain) NSString *tZipcode; //邮编
@property (nonatomic, retain) NSString *towner; //投保人账户所有人
@property (nonatomic, retain) NSString *tpaybank; //银行转账付款账号
@property (nonatomic, retain) NSString *treceivebank; //投保人银行转账给付账号
@property (nonatomic, retain) NSString *taddress; //通讯地址

@property (nonatomic, retain) NSString *bname; //被保险人姓名
@property (nonatomic, retain) NSString *bbirthday; //出生年月
@property (nonatomic, retain) NSString *bsex; //性别
@property (nonatomic, retain) NSString *bIDnumber; //身份证号
@property (nonatomic, retain) NSString *bdayphone; //被保人日间电话
@property (nonatomic, retain) NSString *bnightphone; //被保人夜间电话
@property (nonatomic, retain) NSString *btelephone; //被保险人手机
@property (nonatomic, retain) NSString *bacceptM; //被保人短信接收
@property (nonatomic, retain) NSString *bworknumber; //被保人职业代码
@property (nonatomic, retain) NSString *breceivebank; //被保险人银行转账给付账号

@property (nonatomic, retain) NSData *cnumber;//保险合同代码
@property (nonatomic, retain) NSData *cname;      //保险合同名称
@property (nonatomic, retain) NSData *cbnames;//被保险人姓名组
@property (nonatomic, retain) NSData *cstatus;//合同状态
@property (nonatomic, retain) NSData *cedu;//保额
@property (nonatomic, retain) NSData *ccost;      //保费
@property (nonatomic, retain) NSData *cendtime;      //缴费期满日

@property (nonatomic, retain) NSString *cfromtime;        //保险合同生效日期
@property (nonatomic, retain) NSString *ctoime;        //保险合同到期日
@property (nonatomic, retain) NSString *cpaytype;       //付款方式
@property (nonatomic, retain) NSString *clastmoney;         //上期保险费
@property (nonatomic, retain) NSString *cjiaofeitype;       //缴费方式
@property (nonatomic, retain) NSString *ccurrentmoney;     //到期保险费
@property (nonatomic, retain) NSString *cpaytime;       //缴费到期日
@property (nonatomic, retain) NSString *cfapiaodata;         //发票打印日期

@property (nonatomic, retain) NSString *mpaymoney;    //贷款本金及利息
@property (nonatomic, retain) NSString *movermoney;     //溢缴保险费
@property (nonatomic, retain) NSString *mlastpay;    //最后一次缴费记录
@property (nonatomic, retain) NSString *mbalance; //主合同生存现金结余
@property (nonatomic, retain) NSString *mhandle; //主合同生存现金处理方式
@property (nonatomic, retain) NSString *mfleave;   //附加合同生存现金结余
@property (nonatomic, retain) NSString *mfhandle;       //附加合同生存现金处理方式
@property (nonatomic, retain) NSString *myearleave;       //年金结余
@property (nonatomic, retain) NSString *myearhandle;    //年金处理方式
@property (nonatomic, retain) NSString *mmoneyleave; //现金红利结余
@property (nonatomic, retain) NSString *mmoneyhandle;        //现金红利处理方式
@property (nonatomic, retain) NSString *mreceiveman;//年金受领人
@property (nonatomic, retain) NSString *mnotselect;     //保险费过期未付选择
@property (nonatomic, retain) NSString *mdiedeal;        //全残失能损失收入保险金的处理方式
@property (nonatomic, retain) NSString *mstory;    //是否有理赔史
@property (nonatomic, retain) NSString *mwanneng;//万能险年金领取
@property (nonatomic, retain) NSString *mbaodan;//电子保单
@property (nonatomic, retain) NSString *mcardnumber;       //TPA服务卡卡号
@property (nonatomic, retain) NSString *mcarddate;//TPA服务卡有效期
@end



