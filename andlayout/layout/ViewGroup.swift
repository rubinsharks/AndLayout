//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

// ViewGroup is consist of RootLayout, LinearLayout, RelativeLayout, FrameLayout
protocol ViewGroup: View {
    func addView(tag: String, attr: [String: String]) -> View?
    func removeView(view: View)
    func findViewById(id: String) -> View?
    func getMatchWidth() -> CGFloat
    func getMatchHeight() -> CGFloat

    /*
    이것은 2Pass 레이아웃 배치를 하기 위한 메소드입니다.
    2Pass레이아웃 배치가 필요한 이유는 여러 이유중 wrap_content의 지원 이유가 가장 큽니다.
    Xml을 이용한 View배치는 XML Parser를 이용하며 ViewGroup이 끝나는 시점에 그 안의 모든 View의 wrap_content 사이즈 배치가 결정되기 때문에
    그 정보를 토대로 ViewGroup의 wrap_content의 사이즈도 결정 내릴 수 있습니다.
    이유는 2Pass이지만 결국 이 메소드가 하는 일은 "재배치"이기 때문에 어떤 레이아웃 변경사항에 대한 재배치를 하기 위해서도 사용할 수 있습니다.
    */
    func requestLayout()
}