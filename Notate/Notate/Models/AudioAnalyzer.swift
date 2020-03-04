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
        //FIXME: 123
//        print(forwardOutputImag[12],forwardOutputImag[13])
        //TODO: Apply filters
        print(componentFrequencies)
        var max_freq_coe  = FFTResult(freq: 0.0, Amp: 0.0)
        for freq in componentFrequencies{
            let rFreq = Float(freq)/Float(totSamples)*Float(sampleRate)
            
            let amp = (pow(forwardOutputImag[freq],2)+pow(forwardOutputReal[freq],2))
            print("Freq:\(rFreq) : \(amp)")
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
//        res_note=res_note.replacingOccurrences(of: "i", with: String(note_step))
        res_note=res_note.replacingOccurrences(of: "i", with: "")
        print(freq,n,note_step,rest_step,res_note)
        return res_note
    }
}
