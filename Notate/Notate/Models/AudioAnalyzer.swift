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
    let n = vDSP_Length(2048)

    let frequencies: [Float] = [1, 5, 25, 30, 75, 100,
                                300, 500, 512, 1023]
    
    var FFTResults : [FFTResult]=[]
    func analysis()->[FFTResult]{
        print(n)
        let sampleRate = 42000
        let TimeInterval = 1.0/Float(sampleRate)
        let totSamples = 2000
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent("Test.m4a")
        

//        let url = Bundle.main.url(forResource: "Test", withExtension: "m4a")!
        let file = try! AVAudioFile(forReading: filePath)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)

        let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: (AVAudioFrameCount(totSamples)))
        try! file.read(into: buf!)

        // this makes a copy, you might not want that
        let floatArray = Array(UnsafeBufferPointer(start: buf?.floatChannelData?[0], count:Int(buf!.frameLength)))
        
        let signal=floatArray

//        print("floatArray \(floatArray)\n")
        
//        let tau: Float = .pi * 2
//        let signal: [Float] = (0 ... n).map { index in
//            frequencies.reduce(0) { accumulator, frequency in
//                let normalizedIndex = Float(index) / Float(n)
//                return accumulator + sin(normalizedIndex * frequency * tau)
//            }
//        }
        
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
        let componentFrequencies = forwardOutputImag.enumerated().filter {
            $0.element < -1
        }.map {
            return $0.offset
        }
        print(forwardOutputImag[12],forwardOutputImag[13])
        
        // Prints "[1, 5, 25, 30, 75, 100, 300, 500, 512, 1023]"
        print(componentFrequencies)
        for freq in componentFrequencies{
            let rFreq = Float(freq)/Float(totSamples)/TimeInterval
            print("Freq:\(rFreq) : \(forwardOutputImag[freq-1])")
            FFTResults.append(FFTResult(freq: rFreq, Amp: forwardOutputImag[freq-1]))
        }
        return FFTResults
    }
}
