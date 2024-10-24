import UIKit
import Lottie

final class AnimationsViewController: UIViewController {
    
    private struct Constants {
        static let animationNames = ["animation1", "animation2", "animation3"]
        static let initialAnimationIndex = 0
        static let buttonDimension: CGFloat = 60
        static let buttonInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        static let playPausePointSize: CGFloat = 40
        static let controlButtonPointSize: CGFloat = 30
        static let sliderMinValue: Float = 0.5
        static let sliderMaxValue: Float = 2.0
        static let sliderInitialValue: Float = 1.0
        static let horizontalStackSpacing: CGFloat = 8
        static let verticalStackSpacing: CGFloat = 65
        static let controlButtonStackSpacing: CGFloat = 5
        static let controlsContainerStackSpacing: CGFloat = 10
        static let animationInfoStackSpacing: CGFloat = 8
        static let timecodeInitial = "0:00"
    }
    
    private lazy var createConfigurationButton: (UIImage, CGFloat) -> UIButton = { image, pointSize in
        var config = UIButton.Configuration.plain()
        
        config.image = image
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
        config.contentInsets = Constants.buttonInsets
        
        let button = UIButton(configuration: config)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.buttonDimension),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonDimension)
        ])
        
        return button
    }
    
    // MARK: Buttons
    
    private lazy var playPauseButton: UIButton = {
        let button = createConfigurationButton(.play, Constants.playPausePointSize)
        return button
    }()
    
    private lazy var previusButton: UIButton = {
        let button = createConfigurationButton(.backward, Constants.playPausePointSize)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = createConfigurationButton(.forward, Constants.playPausePointSize)
        return button
    }()
    
    private lazy var controlsContainer: UIView = {
        let view = UIView()
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(previusButton)
        view.addSubview(playPauseButton)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            previusButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -10),
            previusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 10),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [animationView, controlsContainer])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        loadAnimation(ar: Constants.initialAnimationIndex, autoPlay: true)
    }
    
    func setupView() {
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func loadAnimation(ar index: Int, autoPlay: Bool) {
        let animationName = Constants.animationNames[index]
        animationView.animation = LottieAnimation.named(animationName)
        
        if autoPlay {
            animationView.play()
        } else {
            animationView.stop()
        }
    }
}
