//
//  ExtensionString.swift
//  FirebaseToDo
//
//  Created by Duxxless on 02.05.2022.
//

import Foundation

extension String {
    // Для возможности вставки русских слов в ссылку
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
