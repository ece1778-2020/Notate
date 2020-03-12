//
//  AudioAnalyzer.swift
//  Notate
//
//  Created by Yilun Huang on 2020-02-04.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import Foundation
import Combine
import AVFoundation
import Accelerate

class AudioAnalyze{
    

    let frequencies: [Float] = [1, 5, 25, 30, 75, 100,
                                300, 500, 512, 1023]
    
    var FFTResultsList : [FFTResult]=[]
    
    func singlePitch(buf:AVAudioPCMBuffer)->FFTResult{
        var tmp_FFTResultsList : [FFTResult]=[]
        let sampleRate = 12000
        let TimeInterval = 1.0/Float(sampleRate)
        let totSamples = 4096
        let n = vDSP_Length(totSamples)
        
        var floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
        var hanningWindow=[Float](repeating: 0, count: totSamples)
        vDSP_hann_window(&hanningWindow,vDSP_Length(totSamples),Int32(vDSP_HANN_DENORM))
        floatArray=zip(floatArray,hanningWindow).map{$0 * $1}
        let signal=floatArray

                
        let log2n = vDSP_Length(log2(Float(n)))

        guard let fftSetUp = vDSP.FFT(log2n: log2n,
                                              radix: .radix2,
                                              ofType: DSPSplitComplex.self) else {
                                                fatalError("Can't create FFT Setup.")
                }
                let halfN = Int(n / 2)
                        
                var forwardInputReal = [Float](repeating: 0,
                                               count: halfN)
                var forwardInputImag = [Float](repeating: 0,
                                               count: halfN)
                var forwardOutputReal = [Float](repeating: 0,
                                                count: halfN)
                var forwardOutputImag = [Float](repeating: 0,
                                                count: halfN)
                
                forwardInputReal.withUnsafeMutableBufferPointer { forwardInputRealPtr in
                    forwardInputImag.withUnsafeMutableBufferPointer { forwardInputImagPtr in
                        forwardOutputReal.withUnsafeMutableBufferPointer { forwardOutputRealPtr in
                            forwardOutputImag.withUnsafeMutableBufferPointer { forwardOutputImagPtr in
                                
                                // 1: Create a `DSPSplitComplex` to contain the signal.
                                var forwardInput = DSPSplitComplex(realp: forwardInputRealPtr.baseAddress!,
                                                                   imagp: forwardInputImagPtr.baseAddress!)
                                
                                // 2: Convert the real values in `signal` to complex numbers.
                                signal.withUnsafeBytes {
                                    vDSP.convert(interleavedComplexVector: [DSPComplex]($0.bindMemory(to: DSPComplex.self)),
                                                 toSplitComplexVector: &forwardInput)
                                }
                                
                                // 3: Create a `DSPSplitComplex` to receive the FFT result.
                                var forwardOutput = DSPSplitComplex(realp: forwardOutputRealPtr.baseAddress!,
                                                                    imagp: forwardOutputImagPtr.baseAddress!)
                                
                                // 4: Perform the forward FFT.
                                fftSetUp.forward(input: forwardInput,
                                                 output: &forwardOutput)
                            }
                        }
                    }
                }

                let componentFrequencies = forwardOutputImag.enumerated().map {
                            return $0.offset
                        }
        //        print(forwardOutputImag[12],forwardOutputImag[13])
                var max_freq_coe  = FFTResult(freq: 0.0, Amp: 0.0)
                for freq in componentFrequencies{
                    let rFreq = Float(freq)/Float(totSamples)*Float(sampleRate)
                    
                    let amp = (pow(forwardOutputImag[freq],2)+pow(forwardOutputReal[freq],2))
                    if (amp > max_freq_coe.Amp && rFreq>55){
                        max_freq_coe=FFTResult(freq: rFreq, Amp: amp)
                    }
                    tmp_FFTResultsList.append(FFTResult(freq: rFreq, Amp:amp ))
                    
                }
        tmp_FFTResultsList.sort(by: {$0.Amp > $1.Amp})
        var frequencyCount:[String:Int]=[:]
        var cnt=0
        var i=0
        while (cnt<100){
            if (tmp_FFTResultsList[i].freq<1100 && tmp_FFTResultsList[i].freq>80){
                if (frequencyCount[self.freq_to_note(freq: tmp_FFTResultsList[i].freq)] != nil){
                frequencyCount[self.freq_to_note(freq: tmp_FFTResultsList[i].freq)]!+=1
                }else{
                    frequencyCount[self.freq_to_note(freq: tmp_FFTResultsList[i].freq)]=1
                }
                cnt+=1
            }
            i+=1
        }
        cnt=0
        for (key,value) in frequencyCount{
            if (value>cnt){
                cnt=value
                max_freq_coe.Note=key
            }
        }
//        print(max_freq_coe.freq)
//        max_freq_coe.Note=self.freq_to_note(freq: max_freq_coe.freq)
        print(frequencyCount)
        print(max_freq_coe.Note)
        return max_freq_coe
    }

    
    func audio_slicer(fileName:String,startPosition:Int64)->AVAudioPCMBuffer{
        let sampleRate = 12000
        let TimeInterval = 1.0/Float(sampleRate)
        let totSamples = 4096
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent(fileName)
        let file = try! AVAudioFile(forReading: filePath)
//        file.framePosition=Int64(0)
        file.framePosition=startPosition
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)
        let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: (AVAudioFrameCount(totSamples)))
        try! file.read(into: buf!)
        return buf!
    }
    
    func get_start_point(fileName:String) -> Int64{
        var startFramePosition : Int64 = 0
        var arrayStartFramePosition  = 0
        var arrayCountSize  = 120
        var frameCountSize = 1200
        var preSliceSum : Float = 0
        var curSliceSum : Float = 0
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent(fileName)
                
        let file = try! AVAudioFile(forReading: filePath)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)
        while true{
            file.framePosition=startFramePosition
            let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: (AVAudioFrameCount(frameCountSize)))
            try! file.read(into: buf!)
            let floatArray = Array(UnsafeBufferPointer(start: buf?.floatChannelData?[0], count:Int(buf!.frameLength)))
            arrayStartFramePosition = 0
            while (arrayStartFramePosition+arrayCountSize<=frameCountSize){
                curSliceSum=floatArray[arrayStartFramePosition...arrayStartFramePosition+arrayCountSize-1].reduce(0, +)
                if (preSliceSum>0 && curSliceSum>preSliceSum*10 && curSliceSum>0.1){
                    print("sum:\(curSliceSum)")
                    return startFramePosition+Int64(arrayStartFramePosition)
                }
                preSliceSum=curSliceSum
                arrayStartFramePosition+=arrayCountSize
            }
            startFramePosition+=Int64(frameCountSize)
        }
    }
    
    func multy_note(fileName:String,bpm:Int=60)->[FFTResult]{
        var tmp_FFTResultsList : [FFTResult]=[]
        let sampleRate = 12000
        let TimeInterval = 1.0/Float(sampleRate)
        let totSamples = 4096
        var startPosition : Int64 = 0
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent(fileName)
        let file = try! AVAudioFile(forReading: filePath)
        let fileLength=file.length
        
        startPosition=self.get_start_point(fileName: fileName)
        print("Start at :\(startPosition)")
        while (Int(startPosition)+sampleRate<fileLength-1){
            let buf = self.audio_slicer(fileName: fileName, startPosition: (startPosition+Int64(300)))
            tmp_FFTResultsList.append(self.singlePitch(buf: buf))
            startPosition+=Int64(sampleRate)
        }
        print(tmp_FFTResultsList)
        return tmp_FFTResultsList
    }
    
    func analysis(fileName:String)->[FFTResult]{
        var tmp_FFTResultsList : [FFTResult]=[]
        let sampleRate = 12000
        let TimeInterval = 1.0/Float(sampleRate)
        let totSamples = 4096
        let n = vDSP_Length(totSamples)
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let filePath = documentPath.appendingPathComponent("Test.m4a")
        let filePath = documentPath.appendingPathComponent(fileName)
        

//        let url = Bundle.main.url(forResource: "Test", withExtension: "m4a")!
        let file = try! AVAudioFile(forReading: filePath)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)
        
        //---------------------------------
        //Buffer the totSamples counts sample
        let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: (AVAudioFrameCount(totSamples)))
        try! file.read(into: buf!)
        let floatArray = Array(UnsafeBufferPointer(start: buf?.floatChannelData?[0], count:Int(buf!.frameLength)))
        
        let signal=floatArray

        
        let log2n = vDSP_Length(log2(Float(n)))

        guard let fftSetUp = vDSP.FFT(log2n: log2n,
                                      radix: .radix2,
                                      ofType: DSPSplitComplex.self) else {
                                        fatalError("Can't create FFT Setup.")
        }
        let halfN = Int(n / 2)
                
        var forwardInputReal = [Float](repeating: 0,
                                       count: halfN)
        var forwardInputImag = [Float](repeating: 0,
                                       count: halfN)
        var forwardOutputReal = [Float](repeating: 0,
                                        count: halfN)
        var forwardOutputImag = [Float](repeating: 0,
                                        count: halfN)
        
        forwardInputReal.withUnsafeMutableBufferPointer { forwardInputRealPtr in
            forwardInputImag.withUnsafeMutableBufferPointer { forwardInputImagPtr in
                forwardOutputReal.withUnsafeMutableBufferPointer { forwardOutputRealPtr in
                    forwardOutputImag.withUnsafeMutableBufferPointer { forwardOutputImagPtr in
                        
                        // 1: Create a `DSPSplitComplex` to contain the signal.
                        var forwardInput = DSPSplitComplex(realp: forwardInputRealPtr.baseAddress!,
                                                           imagp: forwardInputImagPtr.baseAddress!)
                        
                        // 2: Convert the real values in `signal` to complex numbers.
                        signal.withUnsafeBytes {
                            vDSP.convert(interleavedComplexVector: [DSPComplex]($0.bindMemory(to: DSPComplex.self)),
                                         toSplitComplexVector: &forwardInput)
                        }
                        
                        // 3: Create a `DSPSplitComplex` to receive the FFT result.
                        var forwardOutput = DSPSplitComplex(realp: forwardOutputRealPtr.baseAddress!,
                                                            imagp: forwardOutputImagPtr.baseAddress!)
                        
                        // 4: Perform the forward FFT.
                        fftSetUp.forward(input: forwardInput,
                                         output: &forwardOutput)
                    }
                }
            }
        }
        
        //Filter
//        let componentFrequencies = forwardOutputImag.enumerated().filter {
//            $0.element < -1
//        }.map {
//            return $0.offset
//        }
        let componentFrequencies = forwardOutputImag.enumerated().map {
                    return $0.offset
                }
        var max_freq_coe  = FFTResult(freq: 0.0, Amp: 0.0)
        for freq in componentFrequencies{
            let rFreq = Float(freq)/Float(totSamples)*Float(sampleRate)
            
            let amp = (pow(forwardOutputImag[freq],2)+pow(forwardOutputReal[freq],2))
//            print("Freq:\(rFreq) : \(amp)")
            if (amp > max_freq_coe.Amp){
                max_freq_coe=FFTResult(freq: rFreq, Amp: amp)
            }
            
            tmp_FFTResultsList.append(FFTResult(freq: rFreq, Amp:amp ))
        }
//        FFTResultsList.append(max_freq_coe)
//        images.sort({ $0.fileID > $1.fileID })
        self.freq_to_note(freq: max_freq_coe.freq)
        tmp_FFTResultsList.sort(by: {$0.Amp > $1.Amp})
        var i : Int = 0
//        i = min(5,tmp_FFTResultsList.count)-1
//        FFTResultsList=Array(tmp_FFTResultsList[0...i])
        while (i<tmp_FFTResultsList.count && i<5){
            var a :FFTResult = FFTResult(freq: tmp_FFTResultsList[i].freq, Amp: tmp_FFTResultsList[i].Amp)
            a.Note=self.freq_to_note(freq: a.freq)
            FFTResultsList.append(a)
            i+=1
        }
        return FFTResultsList
    }
    
    func freq_to_note(freq:Float)->String{
        if (freq<55){
            return "Error"
        }
        let note_at_freq_list=["Ai","Ai#","Bi","Ci","Ci#","Di","Di#","Ei","Fi","Fi#","Gi","Gi#"]
        let A1 :Float = 55.00
        let A4 :Float = 440.00
        let r = freq / A1
        let n = log2(r)*12
        var step:Int
        if (Int(n)*2 == Int(n*2)){
            step = Int(n)
        } else{
            step = Int(n)+1
        }
        var note_step:Int = (step / 12 )+1
        let rest_step:Int = step % 12
        
        if (rest_step>2){
            note_step+=1
        }
        var res_note : String = note_at_freq_list[rest_step]
        res_note=res_note.replacingOccurrences(of: "i", with: String(note_step))
//        res_note=res_note.replacingOccurrences(of: "i", with: "")
//        print(freq,n,note_step,rest_step,res_note)
        return res_note
    }
}
