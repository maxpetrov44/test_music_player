//
//  SecondViewController.swift
//  image_load_demo
//
//  Created by Max Petrov on 03.09.2021.
//

import UIKit
import AVFAudio
import RealmSwift

class SecondViewController: UIViewController {
    
    var dbManager: DBManager!
    var trackInfo: DetailedTrackInfo!
    var networkServices: NetworkService!
    var trackTimer: Timer!
    
    
    
    var player: AVAudioPlayer!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timeIndicator: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addToFavouritesButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        networkServices = NetworkService()
        updateUI()
        configurePlayer()
        configureUI()
        dbManager = DBManagerImpl.shared
        // Do any additional setup after loading the view.
    }
    @IBAction func addToFavouritesButtonTapped(_ sender: Any) {
        if trackInfo.isFavourite {
            dbManager.delete(trackInfo)
        } else {
            let i = trackInfo.copy() as! DetailedTrackInfo
            dbManager.save(i)
        }
        trackInfo.isFavourite.toggle()
        updateFavouritesButton()
    }
        //guard let collectionViewController = storyboard.instantiateViewController(identifier: "CollectionViewController") as? CollectionViewController else {return}
       // collectionViewController.realm = realm
    
    private func configureUI() {
        playButton.layer.cornerRadius = playButton.frame.height / 2
        timeIndicator.layer.cornerRadius = 2
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [view.backgroundColor!.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0,1]
        gradientLayer.frame = CGRect(x: 0, y: view.frame.midY, width: view.frame.width, height: view.frame.height / 2)
        view.layer.insertSublayer(gradientLayer, above: imageView.layer)
        upperButtonsConfiguration([backButton, addToFavouritesButton])
        updateFavouritesButton()
    }
    
    private func updateFavouritesButton() {
        let image = trackInfo.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        addToFavouritesButton.setImage(image, for: .normal)
    }
    private func upperButtonsConfiguration(_ buttons: [UIButton]) {
        buttons.forEach { button in
            button.layer.masksToBounds = false
            button.layer.shadowOpacity = 0.5
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: -1, height: 1)
            button.layer.shadowRadius = 3
        }
        
    }
    private func getImage(){
        networkServices.downloadImage(trackInfo.artworkUrl100) {
            imageData in
            guard let imageData = imageData else { return }
            self.imageView.image = UIImage(data: imageData)
        }
    }
    
    private func updateUI() {
        getImage()
        trackNameLabel.text = trackInfo.trackName
        artistNameLabel.text = trackInfo.artistName
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            trackTimer.invalidate()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            trackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                let currentTime = player.currentTime
                let totalTime = player.duration
                let progress = Float(currentTime / totalTime)
                self.currentTimeLabel.text = currentTime.stringFromTimeInterval()
                self.timeIndicator.setProgress(progress, animated: true)
                
            }
        }
        
    }
    private func configurePlayer() {
        timeIndicator.setProgress(0, animated: false)
        networkServices.downloadTrack(trackInfo.previewUrl) { url in
            do {
                self.player = try AVAudioPlayer.init(contentsOf: url)
                self.player.prepareToPlay()
                self.player.volume = 0.5
                self.player.delegate = self
                DispatchQueue.main.async {
                    self.totalTimeLabel.text = self.player.duration.stringFromTimeInterval()
                }
            }
            catch let error {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
}

extension SecondViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        trackTimer.invalidate()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
}

extension TimeInterval {
    
    func stringFromTimeInterval() -> String {
        let time =  NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
}



    

