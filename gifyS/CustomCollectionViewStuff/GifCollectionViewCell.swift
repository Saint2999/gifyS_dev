import SnapKit
//import Alamofire

class GifCollectionViewCell: UICollectionViewCell
{
    let mainImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.systemPurple
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: CGRect())
        self.contentView.addSubview(mainImageView)
        self.backgroundColor = UIColor.systemGray5
        self.layer.cornerRadius = 20
        
        mainImageView.image = UIImage(systemName: "sparkles")
        mainImageView.snp.makeConstraints
        {
            make in
            make.width.height.equalToSuperview()
        }
        
//        let gif_url = "https://api.giphy.com/v1/gifs/random?&api_key=YAmokY0BTS38W0ynjXpAq1uJYmfjHYdj"
//
//        let request = AF.request(gif_url)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
