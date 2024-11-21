//
//  RecordingViewModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/21/24.
//

import Foundation
import Combine
import AVFoundation

class RecordingViewModel: ObservableObject {
    
    enum Action {
        case load
        case startRecording
        case stopRecording
    }
    
    @Published var phase: Phase = .notRequested
    @Published var isRecording: Bool = false
    @Published var soundLevel: CGFloat = 0.0
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .load:
            self.phase = .loading
            self.phase = .success
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = directory.appendingPathComponent("recording.wav")
            
            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                print("파일이 존재하지 않습니다.")
                self.phase = .error
                return
            }
            
            //TODO: - 서버로 전송
            
        case .startRecording:
            startRecording()
            
        case .stopRecording:
            stopRecording()
        }
    }
    
    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = directory.appendingPathComponent("recording.wav")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false
            ]
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            startMonitoring()
            
            self.isRecording = true
        } catch {
            print("녹음 시작 실패 : \(error)")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        timer?.invalidate()
        self.isRecording = false
    }
    
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.audioRecorder?.updateMeters()
            if let power = self?.audioRecorder?.averagePower(forChannel: 0) {
                self?.soundLevel = self?.normalizeSoundLevel(level: power) ?? 0.0
            }
        }
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let minDb: Float = -80.0
        let clampedLevel = max(minDb, level)
        return CGFloat((clampedLevel + 80.0) / 80.0)
    }
    
    deinit {
        audioRecorder?.stop()
        timer?.invalidate()
    }
}
