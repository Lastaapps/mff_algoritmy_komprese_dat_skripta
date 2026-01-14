#import "../definitions.typ": *

#pagebreak()

= Introduction to Lossy Data Compression

Lossy data compression achieves higher compression ratios by discarding some information that is deemed less important or imperceptible to humans. This results in an approximation of the original data.

== Measuring the Loss of Information

To evaluate lossy compression, we need metrics to quantify the "loss" or distortion introduced.

- *Mean Squared Error (MSE)*:
  $ sigma^2 = 1/n sum_(i=1)^n (x_i - y_i)^2 $
  Where $x_i$ is the original data and $y_i$ is the reconstructed data. It measures the average squared difference between original and compressed data.

- *Signal to Noise Ratio (SNR)*:
  $ "SNR"("dB") = 10 log_10 ( (1/n sum_(i=1)^n x_i^2) / sigma^2 ) $
  Measures the ratio of signal power to noise power, expressed in decibels. Higher SNR indicates better quality.

- *Peak Signal to Noise Ratio (PSNR)*:
  $ "PSNR"("dB") = 10 log_10 ( (max_i x_i^2) / sigma^2 ) $
  Similar to SNR, but uses the maximum possible pixel value instead of the average signal power. Commonly used for image and video compression.

== Digitizing Sound

Sound is an analog phenomenon, so to process and compress it digitally, it must be converted from analog to digital form.

- *Sound*: A physical disturbance (pressure wave) that propagates through a medium and is perceived by the auditory system.
- *Frequency*: The number of oscillations per second, measured in Hertz (Hz). Humans typically hear sounds between 20 Hz and 20 kHz.
- *Amplitude*: The intensity or loudness of the sound wave.

=== Capturing Audio: Sampling and Quantization
The analog-to-digital conversion of sound involves two main steps:

1. *Sampling*: Converting a continuous time signal into a discrete time signal by taking measurements at regular intervals.
2. *Quantization*: Converting a continuous amplitude signal into a discrete amplitude signal by mapping continuous values to a finite set of discrete levels.

#info_box(title: "Nyquist-Shannon Sampling Theorem", [
  To accurately reconstruct an analog signal with a highest frequency component $F$, the sampling frequency $F_s$ must be at least twice the highest frequency:
  $ F_s >= 2F $
  Failure to meet this condition leads to *aliasing*, where higher frequencies are incorrectly represented as lower frequencies.
])

*Typical Sampling Frequencies*:
- 48 kHz (professional audio)
- 44.1 kHz (CD quality audio)
- 22.05 kHz (radio quality)
- 11.025 kHz (telephony)

*Resolution (Quantization Levels)*:
- 16-bit (e.g., 96 dB dynamic range for CD quality)
- 8-bit (48 dB)
- 4-bit (24 dB)

== Quantization

Quantization is the process of mapping values from a large (often continuous) set to a smaller (discrete) set.

- *Quantizer*: A function that performs quantization.
- *Scalar Quantization*: Quantizes each sample independently.
- *Vector Quantization*: Quantizes blocks of samples together.

=== Types of Quantizers
- *Uniform Quantization*: Uses quantization intervals of equal length. This is optimal when the input data has a uniform probability distribution.
  - *Midrise Quantizer*: The origin (0) is at the midpoint of an interval. Used when the number of quantization levels $M$ is even.
  - *Midtread Quantizer*: The origin (0) is an endpoint of an interval, resulting in a quantization level at zero. Used when $M$ is odd.
- *Nonuniform Quantization*: Uses quantization intervals of varying lengths, typically shorter intervals for more probable values and longer intervals for less probable values. This is suitable for signals with non-uniform probability distributions (e.g., speech, which often has a concentration of small amplitudes).

=== Adaptive Quantization
Adaptive quantizers adjust their parameters (e.g., step size, interval boundaries) based on the characteristics of the input signal.

- *Forward Adaptive Quantization (Off-line)*: Analyzes blocks of input data first to set quantizer parameters, which are then transmitted as side information.
- *Backward Adaptive Quantization (On-line)*: Adjusts parameters based on previously quantized (and decoded) samples. No side information is needed. The *Jayant quantizer* is a common example, where the step size is adjusted based on the output of the previous quantization step.

== Companding: $\mu$-law and A-law
Companding (compressing + expanding) is a form of non-uniform quantization that first compresses the dynamic range of the analog signal before uniform quantization, and then expands it after decoding. This effectively provides more quantization levels for small amplitude signals.

- *$\mu$-law (Mu-law)*: Used in North American and Japanese telephony systems. It provides higher dynamic range and noise reduction in blocks of silence.
- *A-law*: Used in European telephony systems. It offers lower relative distortion for small values.

Both $\mu$-law and A-law are standardized in ITU-T G.711 for pulse-code modulation (PCM) of voice frequencies. They map 14-bit (for $\mu$-law) or 13-bit (for A-law) linear PCM samples to 8-bit companded samples, reducing the data rate from 64 Kbps to 48-56 Kbps with acceptable voice quality.

== Problems

#task(title: "Signal-to-Noise Ratio (SNR) for Uniform Quantization", [
  *Question*: Show that for a signal with a uniform probability distribution, quantized with a uniform n-bit quantizer, the Signal-to-Noise Ratio (SNR) is approximately $6.02n$ dB.

  *Solution*:
  - With n-bit samples, we have $2^n$ quantization levels.
  - For a uniform signal distribution, the quantization error (noise) can be modeled as a uniform random variable with a variance of approximately $Delta^2/12$, where $Delta$ is the step size.
  - The total signal range is proportional to $2^n Delta$. The signal variance is proportional to $(2^n Delta)^2$.
  - The SNR in dB is given by $10 log_{10}("Signal Power" / "Noise Power")$.
  - $"SNR" = 10 log_{10}( ((2^n Delta)^2 / k_1) / (Delta^2 / 12) )$ for some constant $k_1$.
  - $"SNR" approx 10 log_{10}( (2^n)^2 ) = 20 log_{10}(2^n) = 20n log_{10}(2)$.
  - Since $log_{10}(2) approx 0.301$, the SNR is approximately $20n dot 0.301 = 6.02n$ dB.
  - For a 16-bit sample, this gives an SNR of approximately $16 dot 6.02 approx 96$ dB.
])
