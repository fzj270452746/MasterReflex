import UIKit
import WebKit
import AppsFlyerLib

private var Zvyaytse = [String]()
//internal var HuntOrderKrajs = [String()]

//rechargeClick,amount,recharge,jsBridge,withdrawOrderSuccess,params,firstrecharge,firstCharge,charge,currency,addToCart,openWindow,deposit

let Brie = Zvyaytse[0]              //jsBridge
let NBrie = Zvyaytse[1]  //
let amt = Zvyaytse[2]     //amount
let ren = Zvyaytse[3]      //currency
let OpWin = Zvyaytse[4]      //openWindow
let MUnt = Zvyaytse[5]       //USD
let EvKy = Zvyaytse[6]       //eventKey
let EvVue = Zvyaytse[7]      //eventValue

//let diaChon = husnOjauehs[0]      //rechargeClick
//let amt = husnOjauehs[1]     //amount
//let chozh = husnOjauehs[2]      //recharge
//let Brie = husnOjauehs[3]              //jsBridge
//let hdrawo = husnOjauehs[4]   //withdrawOrderSuccess
//let rams = husnOjauehs[5]      //params
//let diyicicho = husnOjauehs[6]      //firstrecharge
//let diyichCha = husnOjauehs[7]    //firstCharge
//let geicho = husnOjauehs[8]         //charge
//let ren = husnOjauehs[9]      //currency
//let aTc = husnOjauehs[10]  //addToCart
//let OpWin = husnOjauehs[11]      //openWindow
//let deop = husnOjauehs[12]       //deposit


internal class KzoiutzFrztaCV: UIViewController,WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    var hzidin: Fznauts?
    var vmkso: WKWebView?
    
    private var kaoieus: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if hzidin!.cbuays != nil {
            view.backgroundColor = UIColor.init(hexString: hzidin!.cbuays!)
        }
        
        AppsFlyerLib.shared().appsFlyerDevKey = hzidin!.wao9iz!
        AppsFlyerLib.shared().appleAppID = hzidin!.cmouex!
        AppsFlyerLib.shared().start { res, err in
            if (err != nil) {
                print(err as Any)
            }
        }
//        let aaq = ADJConfig(appToken: sinakeo!.qtzbzse!, environment: ADJEnvironmentProduction)
////        aaq?.delegate = self
//        Adjust.initSdk(aaq)
//        
        
        Zvyaytse = hzidin!.cvaosu!.components(separatedBy: ",")
//        HuntOrderKrajs = [aTc,diaChon, diyicicho, hdrawo, geicho, chozh, diyichCha, deop]
//        let usrScp = WKUserScript(source: chhzne!.taushg!, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let usCt = WKUserContentController()
//        usCt.addUserScript(usrScp)
        let cofg = WKWebViewConfiguration()
        cofg.userContentController = usCt
        cofg.allowsInlineMediaPlayback = true
        cofg.userContentController.add(self, name: NBrie)
        cofg.defaultWebpagePreferences.allowsContentJavaScript = true
        vmkso = WKWebView(frame: .zero, configuration: cofg)
        vmkso!.allowsBackForwardNavigationGestures = true
        vmkso?.uiDelegate = self
        vmkso?.navigationDelegate = self
        view.addSubview(vmkso!)
        
        
        kaoieus = hzidin!.vsuyzy!
        vmkso?.load(URLRequest(url:URL(string: kaoieus!)!))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = ws.statusBarManager {
            
            let statusBarHeight = hzidin!.nxbsao!.contains("V") ? statusBarManager.statusBarFrame.height : 0
            let bottomHeight = hzidin!.nxbsao!.contains("I") ? view.safeAreaInsets.bottom : 0
            vmkso?.frame = CGRectMake(0, statusBarHeight, view.bounds.width, view.bounds.height - statusBarHeight - bottomHeight)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        let ul = navigationAction.request.url
        if ((ul?.absoluteString.hasPrefix(webView.url!.absoluteString)) != nil) {
            UIApplication.shared.open(ul!)
//            webView.load(navigationAction.request)
        }
        return nil
    }
    
//    @objc private func eabsuhd(_ btn:UIButton) {
//        let v = btn.superview
//        v?.removeFromSuperview()
//    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == NBrie {
            let dic = message.body as! String
            Fszixyyhs(dic)
        }
    }
    
    override var shouldAutorotate: Bool {
        true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .allButUpsideDown
    }
}


//internal class EachCompareNavigationController: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        isNavigationBarHidden = true
//    }
//    
//    override var shouldAutorotate: Bool {
//        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
//    }
//}
