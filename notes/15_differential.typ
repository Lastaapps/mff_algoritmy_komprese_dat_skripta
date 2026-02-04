#import "../definitions.typ": *

#pagebreak()

= Differential Encoding

== The Core Idea
Differential encoding is a predictive coding technique that exploits the high sample-to-sample correlation found in many types of signals, such as speech and images. Instead of encoding the value of each sample directly, it encodes the *difference* between the current sample and a prediction of it.

*Key Rationale*:
- For signals where samples do not change drastically, the sequence of differences ($d_n = x_n - x_(n-1)$) will have a narrower range and smaller variance than the original sequence of samples $x_(n)$.
- This sequence of differences can be quantized and encoded more efficiently.

== Differential Pulse-Code Modulation (DPCM)
DPCM is a fundamental differential encoding technique. It formalizes the idea of encoding the difference between a sample and its prediction.

#info_box(title: "DPCM Algorithm", [
  Instead of using the previous sample as a predictor, a more general function can be used. The goal is to make the prediction error $d_n$ as small as possible.

  - *Prediction*: A prediction $p_n$ of the current sample $x_n$ is made based on previous *reconstructed* samples:
    $ p_n = f(hat(x)_(n-1), $hat(x)_(n-2)$, ...,$hat(x)_(0)$)$
  - *Prediction Error*: The difference to be encoded is:
    $ d_n = x_n - p_n $

  By using previously reconstructed samples, both the encoder and decoder can stay in sync without needing to transmit the predictor itself.
])

=== Linear Predictor
A common choice for the prediction function is a linear combination of previous samples:
$p_n = sum_(i=1)^N a_i hat(x)_(n-i)$
The goal is to find the coefficients $a_i$ that minimize the mean squared error (MSE) of the prediction, $sigma^2 = E[(x_n - p_n)^2]$.

=== Wiener-Hopf Equations
By setting the derivative of the MSE with respect to each coefficient $a_j$ to zero, we arrive at a set of linear equations known as the Wiener-Hopf equations:
$ R A = P $
where $R$ is the autocorrelation matrix of the signal, $A$ is the vector of predictor coefficients, and $P$ is a vector of autocorrelation values. Solving this system yields the optimal linear predictor coefficients.

== Adaptive DPCM (ADPCM)
In practice, signal statistics can change over time. ADPCM adapts the predictor and/or the quantizer to these changes.

- *Forward Adaptive Prediction (DPCM-APF)*: The input is processed in blocks. For each block, autocorrelation coefficients are computed, and optimal predictor coefficients are found. This requires buffering the input and transmitting the coefficients as *side information*.
- *Backward Adaptive Prediction (DPCM-APB)*: The predictor coefficients are updated after each sample, based on the quantized prediction error. This is an online method that does not require side information.

=== LMS (Least Mean Squared) Algorithm
The LMS algorithm is a simple and effective method for backward adaptive prediction. It updates the predictor coefficients iteratively:
$ A^(n+1) = A^(n) + alpha hat(d)_(n) hat(X)_(n-1) $
where $A$ is the vector of coefficients, $alpha$ is a small learning rate, $hat{d}_n$ is the quantized difference, and $hat{X}_(n-1)$ is the vector of past reconstructed samples.

=== G.726 Standard
G.726 is an ITU-T standard for speech compression based on ADPCM.
- *Sampling*: 8 kHz, 8-bit resolution (64 kbps).
- *Output*: Supports various bit rates (16, 24, 32, 40 kbps), with 32 kbps (a 2:1 compression ratio) being the most common.
- *Predictor*: Uses a simplified LMS algorithm to update coefficients.
- *Quantizer*: Employs a backward adaptive quantizer (a modified Jayant quantizer).

== Delta Modulation (DM)
Delta Modulation is a simplified form of DPCM specifically for speech coding.

#info_box(title: "Delta Modulation", [
  - It uses a 1-bit (2-level) quantizer, encoding the difference as either $+Delta$ or $-Delta$.
  - It often involves *oversampling* the signal (sampling at a rate much higher than the Nyquist rate).
])

*Problems with Fixed $Delta$*:
- *Slope Overload*: If the input signal changes too rapidly, the reconstructed signal cannot keep up, leading to large errors.
- *Granular Noise*: If the input signal is constant or changes very slowly, the reconstructed output alternates up and down by $Delta$, creating noise.

=== Adaptive Delta Modulation (ADM)
To solve these problems, the step size $Delta$ can be adapted. In *Constant Factor Adaptive Delta Modulation (CFDM)*, the step size is increased in overload regions and decreased in granular regions.
- The region is identified based on the history of the quantizer output. For example, if the last two outputs were the same sign ($s_(n)$ = $s_(n-1)$), it indicates slope overload, so $Delta$ is increased. If the signs differ, it indicates a granular region, so $Delta$ is decreased.
- This technique was used in early space shuttle to ground terminal communications.
