//
//  ListyTableViewCell.swift
//  Listy
//
//  Created by Kunal Pawar on 11/5/19.
//  Copyright © 2019 Kunal Pawar. All rights reserved.
//

import UIKit

/// Delegate Protocol for making buttons work in the cell
protocol ListyTableCellDelegate {
    func doDelete(_ cell:ListyTableViewCell)
}


class ListyTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCharacter: UILabel!
    @IBOutlet weak var lblActor: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    
    var delegate:ListyTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onClickBtnDelete(_ sender: UIButton) {
        if let delegateObj = self.delegate {
            delegateObj.doDelete(self)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
