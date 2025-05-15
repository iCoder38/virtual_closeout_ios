import UIKit

extension UIViewController {
    func showRatingAlert(onSubmit: @escaping (_ rating: Int, _ description: String) -> Void) {
        let alertVC = UIViewController()
        alertVC.preferredContentSize = CGSize(width: 250, height: 220)
        
        var selectedRating = 0
        
        // Star buttons
        let starStack = UIStackView()
        starStack.axis = .horizontal
        starStack.alignment = .center
        starStack.distribution = .fillEqually
        starStack.spacing = 5
        
        var starButtons: [UIButton] = []
        
        for i in 1...5 {
            let button = UIButton(type: .system)
            button.tag = i
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.tintColor = .systemYellow
            button.addAction(UIAction(handler: { _ in
                selectedRating = i
                for (index, btn) in starButtons.enumerated() {
                    let starImage = index < i ? "star.fill" : "star"
                    btn.setImage(UIImage(systemName: starImage), for: .normal)
                }
            }), for: .touchUpInside)
            starButtons.append(button)
            starStack.addArrangedSubview(button)
        }
        
        // Description TextView
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = .systemFont(ofSize: 14)
        
        // Stack for vertical layout
        let mainStack = UIStackView(arrangedSubviews: [starStack, textView])
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        alertVC.view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: alertVC.view.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: alertVC.view.bottomAnchor, constant: -10),
            mainStack.leadingAnchor.constraint(equalTo: alertVC.view.leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: alertVC.view.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Show alert
        let alert = UIAlertController(title: "Rate Us", message: nil, preferredStyle: .alert)
        alert.setValue(alertVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            onSubmit(selectedRating, textView.text)
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
    
    func showSimpleTwoButtonAlert(
        title: String,
        onPost: @escaping (_ userInput: String) -> Void
    ) {
        let alertVC = UIViewController()
        alertVC.preferredContentSize = CGSize(width: 270, height: 180)
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // TextView for user input
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // Stack for title and input
        let stack = UIStackView(arrangedSubviews: [titleLabel, textView])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        alertVC.view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: alertVC.view.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: alertVC.view.bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: alertVC.view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: alertVC.view.trailingAnchor, constant: -10)
        ])
        
        // UIAlertController wrapper
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(alertVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "No Thanks", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Post", style: .default, handler: { _ in
            onPost(textView.text)
        }))
        
        self.present(alert, animated: true)
    }
    
    func showSnackBar(message: String, duration: TimeInterval = 2.0) {
        let snackBar = UILabel()
        snackBar.text = message
        snackBar.textColor = .white
        snackBar.textAlignment = .center
        snackBar.font = UIFont.systemFont(ofSize: 14)
        snackBar.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        snackBar.layer.cornerRadius = 8
        snackBar.layer.masksToBounds = true
        snackBar.numberOfLines = 0
        
        let height: CGFloat = 40
        let bottomPadding: CGFloat = 30
        
        snackBar.frame = CGRect(
            x: 20,
            y: self.view.frame.height,
            width: self.view.frame.width - 40,
            height: height
        )
        
        self.view.addSubview(snackBar)
        
        UIView.animate(withDuration: 0.3, animations: {
            snackBar.frame.origin.y = self.view.frame.height - height - bottomPadding
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: 0.3, animations: {
                    snackBar.frame.origin.y = self.view.frame.height
                }) { _ in
                    snackBar.removeFromSuperview()
                }
            }
        }
    }
    
    
    
    
    
    func shareProduct(from controller: UIViewController, product: [String: Any]) {
        // Extract text fields
        let productName = product["productName"] as? String ?? "Unnamed Product"
        let description = product["description"] as? String ?? "No description."
        let category = product["categoryName"] as? String ?? "Unknown Category"
        let condition = product["conditions"] as? String ?? "Unknown Condition"

        // Final text to share
        let shareText = """
        🛒 \(productName)
        📂 Category: \(category)
        ✅ Condition: \(condition)

        📝 Description:
        \(description)
        """

        // Image keys
        let imageKeys = ["image_1", "image_2", "image_3", "image_4", "image_5"]
        let imageUrls: [URL] = imageKeys.compactMap {
            guard let str = product[$0] as? String, !str.isEmpty else { return nil }
            return URL(string: str)
        }

        // Download images
        var imagesToShare: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        let syncQueue = DispatchQueue(label: "safe-image-access")

        for url in imageUrls {
            dispatchGroup.enter()
            URLSession.shared.dataTask(with: url) { data, _, _ in
                defer { dispatchGroup.leave() }

                if let data = data, let image = UIImage(data: data) {
                    syncQueue.async {
                        imagesToShare.append(image)
                    }
                }
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {
            var itemsToShare: [Any] = [shareText]
            itemsToShare.append(contentsOf: imagesToShare)

            let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = controller.view // for iPad

            controller.present(activityVC, animated: true)
        }
    }

    
    
    
}
 



