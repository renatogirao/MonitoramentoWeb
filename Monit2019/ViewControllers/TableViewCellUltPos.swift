//
//  TableViewCellUltPos.swift
//  Monit2019
//
//  Created by Marcio Santos on 21/07/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import UIKit

class TableViewCellUltPos: UITableViewCell {

    @IBOutlet weak var lblCoordenada: UILabel!
    @IBOutlet weak var lblHorario: UILabel!
    @IBOutlet weak var lblVelocidade: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
