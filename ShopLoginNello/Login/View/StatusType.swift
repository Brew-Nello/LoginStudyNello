//
//  StatusType.swift
//  ShopLoginNello
//
//  Created by nello on 2022/11/16.
//

import Foundation
/// 로그인 진행상황
enum StatusType {
    case intro   // 진입
    case process // 로그인 중
    case success // 로그인 성공
    
    var title: String {
        switch self {
        case.intro: return "로그인 정보입니다.\n로그인 정보입니다."
        case.process: return "로그인 진행중"
        case.success: return "로그인 완료"
        }
    }
    
}
