//
//  AppGroup.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/05.
//

import Foundation
import SwiftUI
import WidgetKit


struct AppGroup {
    static func makedFileURL(fileName:String)->URL? {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.net.kongbaguni.share")
        return sharedContainer?.appendingPathComponent(fileName)
    }
    
    static func save(dic:[String:Any], url:URL) {
        do {
            let data = try JSONSerialization.data(withJSONObject: dic,options: [])
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveGameData() {
        var dic:[String:Any] = [
            "totalCount" : GameManager.shared.units.count,
        ]
        
        
        var data:[String:Int] = [:]
        for item in GameManager.shared.units {
            if let status = (item as? HandUnit)?.status.rawValue {
                let key = "\(status)"
                if (data[key] == nil) {
                    data[key] = 0
                }
                else {
                    data[key]! += 1
                }
            }
        }
        
        dic["data"] = data
        save(dic: dic, url: makedFileURL(fileName: "game")!)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    static func load(fileUrl:URL)->[String:Any]? {
        do {
            let data = try Data(contentsOf: fileUrl)
            let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            return dic
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func loadGameData()->(data:[(HandUnit.Status,Int)],total:Int)? {
        if let fileUrl = makedFileURL(fileName: "game"),
           let data = load(fileUrl: fileUrl),
           let d = data["data"] as? [String:Int],
           let t = data["totalCount"] as? Int {
            var rd:[(HandUnit.Status,Int)] = []
            for item in d {
                let rawvalue = NSString(string:item.key).integerValue
                rd.append((HandUnit.Status(rawValue: rawvalue)!, item.value))
            }
            rd.sort { a, b in
                return a.1 > b.1
            }
            return (data:rd, total:t)
        }
        return nil
    }
}
