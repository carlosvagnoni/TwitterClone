//
//  RoundedShape.swift
//  TwitterClone
//
//  Created by user239477 on 6/7/23.
//

import SwiftUI

struct RoundedShape: Shape {
    
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 80, height: 80))
        
        return Path(path.cgPath)
        
    }
    
}
