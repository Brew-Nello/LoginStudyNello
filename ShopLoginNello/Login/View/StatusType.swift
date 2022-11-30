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
        case.intro: return "주문하신 상품의 계정으로 로그인하시면\n배송 정보를 실시간으로 볼 수 있어요."
        case.process: return "로그인 중입니다.."
        case.success: return "로그인 성공!"
        }
    }
    
}
