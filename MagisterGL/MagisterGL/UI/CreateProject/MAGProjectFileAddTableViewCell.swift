import UIKit

protocol MAGProjectFileAddTableViewCellDelegate : class
{
  func showGoogleDrive(cellObject: MAGProjectFileAddTableViewCellObject)
}

class MAGProjectFileAddTableViewCell: UITableViewCell
{

  weak var delegate: MAGProjectFileAddTableViewCellDelegate?
  var cellObject: MAGProjectFileAddTableViewCellObject?
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var filePathLabel: UILabel!
  
  override func awakeFromNib()
  {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configure(cellObject: MAGProjectFileAddTableViewCellObject,
                 delegate: MAGProjectFileAddTableViewCellDelegate)
  {
    self.cellObject = cellObject;
    self.titleLabel.text = cellObject.name
    self.filePathLabel.text = cellObject.filePathArray.description
    self.delegate = delegate
  }

  @IBAction func addFile(_ sender: Any)
  {
    self.delegate?.showGoogleDrive(cellObject: self.cellObject!)
  }
  
}
