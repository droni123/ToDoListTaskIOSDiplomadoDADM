//
//  Helpers.swift
//  ToDoListTask
//
//  Created by De la Cruz Hernández on 19/12/22.
//

import Foundation
import UIKit

func validateText(text : String) -> Bool{
    if (text.trimmingCharacters(in: .whitespaces).isEmpty){
        return false
    } else{
        return true
    }
}
