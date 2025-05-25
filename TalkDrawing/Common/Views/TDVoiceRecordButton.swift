import SwiftUI
import AVFoundation
import Speech

enum RecordingMode {
    case tapToToggle    // 点击切换模式
    case holdToRecord   // 长按录制模式
}

class AudioRecorder: NSObject, ObservableObject {
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
    
    @Published var isRecording = false
    @Binding var recognizedText: String
    
    init(recognizedText: Binding<String>) {
        self._recognizedText = recognizedText
        super.init()
        setupAudioSession()
        requestSpeechAuthorization()
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("音频会话设置失败: \(error.localizedDescription)")
        }
    }
    
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("语音识别已授权")
                case .denied:
                    print("用户拒绝了语音识别权限")
                case .restricted:
                    print("设备不支持语音识别")
                case .notDetermined:
                    print("语音识别权限未确定")
                @unknown default:
                    print("未知的授权状态")
                }
            }
        }
    }
    
    func startRecording() {
        // 重置之前的识别任务
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // 配置音频引擎
        audioEngine = AVAudioEngine()
        let inputNode = audioEngine?.inputNode
        
        // 创建识别请求
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            print("无法创建识别请求")
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // 开始识别任务
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }
            
            if error != nil {
                self.stopRecording()
            }
        }
        
        // 配置音频格式
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        // 启动音频引擎
        do {
            try audioEngine?.start()
            isRecording = true
        } catch {
            print("音频引擎启动失败: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        audioEngine = nil
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
    }
}

struct TDVoiceRecordButton: View {
    @StateObject private var audioRecorder: AudioRecorder
    let mode: RecordingMode
    var onRecordingStart: (() -> Void)?
    var onRecordingStop: (() -> Void)?
    
    @State private var isPressed = false
    @State private var scale: CGFloat = 1.0
    
    init(mode: RecordingMode, recognizedText: Binding<String>, onRecordingStart: (() -> Void)? = nil, onRecordingStop: (() -> Void)? = nil) {
        self.mode = mode
        self.onRecordingStart = onRecordingStart
        self.onRecordingStop = onRecordingStop
        _audioRecorder = StateObject(wrappedValue: AudioRecorder(recognizedText: recognizedText))
    }
    
    var body: some View {
        Button {
            if mode == .tapToToggle {
                if audioRecorder.isRecording {
                    print("停止录音")
                    audioRecorder.stopRecording()
                    onRecordingStop?()
                } else {
                    print("开始录音")
                    audioRecorder.startRecording()
                    onRecordingStart?()
                }
            }
        } label: {
            Circle()
                .fill(audioRecorder.isRecording ? Color.red : Color.blue)
                .frame(width: 60, height: 60)
                .scaleEffect(scale)
                .overlay {
                    Image(systemName: audioRecorder.isRecording ? "stop.fill" : "mic.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
        }
        .simultaneousGesture(
            mode == .holdToRecord ?
            LongPressGesture(minimumDuration: 0.1)
                .onEnded { _ in
                    audioRecorder.startRecording()
                    onRecordingStart?()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scale = 1.2
                    }
                }
            : nil
        )
        .simultaneousGesture(
            mode == .holdToRecord ?
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    if isPressed {
                        isPressed = false
                        audioRecorder.stopRecording()
                        onRecordingStop?()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            scale = 1.0
                        }
                    }
                }
            : nil
        )
    }
}

struct TDVoiceRecordButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            TDVoiceRecordButton(mode: .tapToToggle, recognizedText: .constant(""))
            TDVoiceRecordButton(mode: .holdToRecord, recognizedText: .constant(""))
        }
    }
} 
