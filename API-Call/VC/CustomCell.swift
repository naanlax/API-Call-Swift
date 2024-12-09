import UIKit

class CustomCell: UITableViewCell
{
    let itemImageView = UIImageView()
    let nameLabel = UILabel()
    let skuLabel = UILabel()
    let descLabel = UILabel()
    let rateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.cornerRadius = 8
        itemImageView.clipsToBounds = true
        
        skuLabel.font = UIFont.systemFont(ofSize: 14)
        skuLabel.textColor = .darkGray

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black

        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = .gray

        rateLabel.font = UIFont.boldSystemFont(ofSize: 13)
        rateLabel.textColor = .black

        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(skuLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(rateLabel)

        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        skuLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 60),
            itemImageView.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            skuLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            skuLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            skuLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            descLabel.topAnchor.constraint(equalTo: skuLabel.bottomAnchor, constant: 5),
            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            rateLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 5),
            rateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            rateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item : Message)
    {
        itemImageView.image = UIImage(systemName: "photo")
        nameLabel.text = item.name
        descLabel.text = item.description
        skuLabel.text = item.sku
        rateLabel.text = String(item.rate)
    }
}



