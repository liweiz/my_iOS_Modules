//
//  ModuleData.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-01-31.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

// For each line the main moves first and the extra and following lines sync their offset.x with the main. Then the extra moves to adjust visiability, if it is needed.
// The extra's adjustment is to hide the unwanted glyph(s). So after the adjustment finishes, the first hidden  glyph's rect.x must be in the same position as the line view's in the parent view's coordinates. Hence, there is no need to adjust the next line's main to make it's first visiable glyph's rect.x at the same position as the line's rect.x.
// So we can use an array to store the whole change by storing the first element as the first line's main change, the second element as the first line's extra change and so on. Those with no need of change just stored as a 0.

var OffsetXsForLines = [CGFloat]()