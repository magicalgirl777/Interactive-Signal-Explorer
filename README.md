# Interactive Signal Explorer

## Overview

The Interactive Signal Explorer is a MATLAB application developed to demonstrate fundamental Digital Signal Processing (DSP) concepts through an interactive interface.

The program allows users to generate different types of signals, analyze them in both the time and frequency domains, simulate noisy environments, apply digital filters, and visualize the effects of sampling and aliasing.

---

## Features

- Generate different signal types:
  - Sine Wave
  - Cosine Wave
  - Square Wave
  - Sawtooth Wave
  - Triangle Wave

- Time-domain visualization

- Frequency-domain analysis using the Fast Fourier Transform (FFT)

- Add White Gaussian Noise (AWGN) with adjustable Signal-to-Noise Ratio (SNR)

- Digital filtering using Butterworth filters:
  - Low-Pass
  - High-Pass
  - Band-Pass

- Sampling and aliasing demonstration

- Nyquist criterion verification

- Export analysis dashboard as a high-resolution image

---

## MATLAB Concepts Used

- Signal generation
- Sampling
- Time-domain analysis
- Frequency-domain analysis
- Fast Fourier Transform (FFT)
- White Gaussian Noise (AWGN)
- Butterworth filter design
- Zero-phase filtering using `filtfilt`
- Nyquist Sampling Theorem
- Aliasing

---

## How to Run

1. Open `signal_explorer.m` in MATLAB.
2. Run the script.
3. Choose a signal type.
4. Enter the signal amplitude and frequency.
5. Choose whether to add noise.
6. Select a digital filter.
7. (Optional) Explore the sampling and aliasing demonstration.
8. The program displays an interactive dashboard and exports it as an image.

---

## Example Dashboard

![Signal Explorer Dashboard](signal_explorer_dashboard.png)

---

## Future Improvements

Possible future extensions include:

- Additional filter types
- Real-time signal generation
- Audio signal processing
- Spectrogram visualization
- Signal reconstruction after sampling
- GUI using MATLAB App Designer

---

## Skills Demonstrated

- MATLAB programming
- Digital Signal Processing (DSP)
- Signal analysis
- FFT implementation
- Digital filter design
- Data visualization
- Engineering problem solving

---

## Author

**Jana El Kholaiy**

Electronics and Communications Engineering Student

## Notes

This project was developed as part of my Digital Signal Processing learning journey. It combines signal generation, analysis, filtering, and sampling concepts into a single interactive MATLAB application.
