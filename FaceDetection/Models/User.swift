//
//  User.swift
//  FaceDetection
//
//  Created by Plotnikov Mikhail on 22.01.2023.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var uuid: String?
    @objc dynamic var login: String?
    @objc dynamic var password: String?
    @objc dynamic var photo: NSData?
}
