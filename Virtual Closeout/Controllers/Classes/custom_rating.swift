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
}

