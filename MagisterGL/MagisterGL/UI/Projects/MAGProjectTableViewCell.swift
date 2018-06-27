import UIKit

class MAGProjectTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  
  func configure(cellObject: MAGProjectCellObject)
  {
    self.nameLabel.text = cellObject.name
  }
  
  override func awakeFromNib()
  {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
