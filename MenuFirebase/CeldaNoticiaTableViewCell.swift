//
//  CeldaNoticiaTableViewCell.swift
//  MenuFirebase
//
//  Created by Josue Medina on 05/06/22.
//

import UIKit

class CeldaNoticiaTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenNoticiaIV: UIImageView!
    @IBOutlet weak var descripcionNoticiaLabel: UILabel!
    @IBOutlet weak var tituloNoticiaLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
