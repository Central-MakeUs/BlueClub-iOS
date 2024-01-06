//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI

public enum Icons: String {
    
    // MARK: - large
    case add_large
    case calendar_large
    case notification1_large
    case search_large
    
    // MARK: - ic
    case align_both
    case align_center
    case align_left
    case align_right
    case arrow_bottom
    case arrow_left
    case arrow_right
    case arrow_top
    case arrow2_left
    case arrow2_right
    case bold
    case checkpx
    case download
    case font_size
    case font
    case history
    case italic
    case line_height
    case minuspx
    case more
    case paragraph_space
    case pluspx
    case redo
    case refresh
    case share
    case shuffle
    case sync
    case text
    case understroke
    case undo
    case x
    
    // MARK: - outline
    case add_outline
    case add_circle_outline
    case bookmark_outline
    case calendar_outline
    case chat_outline
    case check_outline
    case check_circle_outline
    case clear_outline
    case community_outline
    case copy_outline
    case edit_outline
    case edit_rectangle_outline
    case heart_outline
    case help_circle_outline
    case home_outline
    case image_rectangle_outline
    case information_circle_outline
    case my_outline
    case notification1_outline
    case notification2_outline
    case notification3_outline
    case notification4_outline
    case search1_outline
    case search2_outline
    case setting_outline
    case share_outlined
    case star_outline
    case trash_outline
    case warning_outline
    case warning_circle_outline
    
    // MARK: - solid
    case add_solid
    case add_circle_solid
    case bookmark_solid
    case calendar_solid
    case chat_solid
    case check_circle_solid
    case check_solid
    case clear_solid
    case community_solid
    case copy_solid
    case edit_rectangle_solid
    case edit_solid
    case heart_solid
    case help_circle_solid
    case home_solid
    case image_solid
    case information_circle_solid
    case my_solid
    case notification1_solid
    case notification2_solid
    case notification3_solid
    case notification4_solid
    case search1_solid
    case search2_solid
    case setting_solid
    case share_outline
    case star_solid
    case trash_solid
    case warning_circle_solid
    case warning_solid
    
    // MARK: - social login
    case kakao
    case apple
}

public extension Icons {
    
    var image: Image {
        .icons(self)
    }
}
