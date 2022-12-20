//
//  ToDoTaskViewCell.swift
//  ToDoListTask
//
//  Created by De la Cruz Hernández on 19/12/22.
//

import UIKit

class ToDoTaskViewCell: UITableViewCell {

    
    @IBOutlet weak var taskTitulo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //self.shine()
    }
    
}

