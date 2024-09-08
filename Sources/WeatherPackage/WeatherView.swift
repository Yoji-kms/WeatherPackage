//
//  WeatherView.swift
//  MiniApps
//
//  Created by Yoji on 08.09.2024.
//

import UIKit

public final class WeatherView: UIView {
    private let viewModel = WeatherViewModel()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backgroundColors: [UIColor] = [
        .white,
        .systemMint,
        .systemPink
    ]
    
//    MARK: Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = self.backgroundColors.randomElement()
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Setups
    private func setupViews() {
        self.addSubview(self.label)
        self.update()
        
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.label.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    public func update() {
        self.viewModel.updateWeather() { [weak self] newWeather in
            guard let self else { return }
            DispatchQueue.main.async {
                self.label.text = "\(newWeather)º"
            }
        }
    }
}
