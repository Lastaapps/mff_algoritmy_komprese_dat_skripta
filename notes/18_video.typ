#import "../definitions.typ": *

#pagebreak()

= Video Compression

== Introduction
Video is essentially a time sequence of images (frames). However, video compression differs significantly from still image compression due to the temporal dimension. The human visual system is less sensitive to certain artifacts in moving sequences than in static images.
- *Symmetric vs. Asymmetric Compression*: Two-way communication (e.g., videoconferencing) requires symmetric, fast compression and decompression. One-way communication (e.g., streaming) can tolerate slow, complex compression as long as decompression is fast.

== Video Signal Representation
- *Refresh Rate (fps)*: The number of frames displayed per second. Common rates include 24 fps (film), 25 fps (PAL/SECAM), and 29.97 fps (NTSC).
- *Analog TV Standards*:
  - *NTSC*: Used in North America, with 525 lines and a 4:3 aspect ratio.
  - *PAL/SECAM*: Used in Europe, with 625 lines and a 4:3 aspect ratio.
- *Color Representation*: To maintain compatibility with black-and-white TVs, color signals were split into:
  - *Luminance (Y)*: The brightness or grayscale component.
  - *Chrominance (Cb/Cr or U/V)*: The color difference components. The human eye is less sensitive to detail in chrominance than in luminance.

== Digital Video
- *ITU-R 601 (CCIR 601)*: A foundational standard for digitizing analog video. It uses the YCbCr color space.
- *Chroma Subsampling*: A technique to reduce data by storing chrominance information at a lower resolution than luminance. Common schemes include:
  - *4:4:4*: No subsampling.
  - *4:2:2*: Horizontal subsampling by a factor of 2.
  - *4:2:0*: Horizontal and vertical subsampling by a factor of 2. This saves 50% of the space used by color components.

== H.261 Standard
An early ITU-T standard for videotelephony and videoconferencing, laying the groundwork for modern video compression.

#info_box(title: "H.261 Compression Scheme", [
  1. *Blocking*: The frame is divided into $8 times 8$ blocks.
  2. *Prediction*: A prediction for each block is made, either from the previous frame (inter-frame prediction) or from within the current frame (intra-frame prediction).
  3. *Differencing*: The difference (residual) between the block and its prediction is calculated.
  4. *DCT*: A Discrete Cosine Transform is applied to the residual block.
  5. *Quantization*: The DCT coefficients are quantized.
  6. *Entropy Coding*: The quantized coefficients are losslessly coded.
])

== Motion Compensation
The core of modern video compression is motion compensation, which exploits temporal redundancy between frames.
- *Idea*: Instead of simply using the same position from the previous frame for prediction, the encoder searches for the best-matching block in a search area of the previous frame.
- *Motion Vector*: The displacement between the current block and its best match is encoded as a motion vector.
- *Encoding*: The encoder transmits the motion vector and the quantized residual (the difference between the block and its motion-compensated prediction).

#info_box(title: "H.261 Motion Compensation", [
  - Operates on *macroblocks* ($16 times 16$ luminance block and corresponding chrominance blocks).
  - The search for the best match is performed only on the Y (luminance) component.
  - The search space is limited (e.g., $\pm 15$ pixels) to reduce computational complexity.
])

== MPEG Standards
The MPEG (Moving Picture Experts Group) standards define formats for lossy compression of audio and video.

*MPEG-1 (1993)*:
- Basis for Video CD (VCD) and MP3 audio.
- Based on H.261 but adapted for digital storage and retrieval.

*MPEG-2 (1994)*:
- Standard for DVD, digital TV broadcast (DVB), and HDTV.
- Introduced support for interlaced video and more advanced profiles and levels for different resolutions and bitrates.

*MPEG-4 (2001)*:
- Object-oriented approach, allowing for separate encoding of audio, video, and 3D objects.
- *Part 10 (H.264/AVC)*: A highly efficient codec used for Blu-ray, streaming, and HDTV.

*MPEG-M (Part 2: HEVC / H.265)*:
- Successor to H.264, offering roughly double the compression efficiency. Used in DVB-T2 and for 4K/8K video.

=== MPEG Frame Types
MPEG introduced different frame types to balance compression efficiency and random access capability.
- *I-frame (Intra-frame)*: Coded independently, without reference to any other frame. Acts as an anchor point for decoding.
- *P-frame (Predictive-frame)*: Coded using motion-compensated prediction from a previous I-frame or P-frame.
- *B-frame (Bidirectional-frame)*: Coded using prediction from both a previous *and* a future I-frame or P-frame, offering the highest compression.

A sequence of frames is often organized into a *Group of Pictures (GOP)*, e.g., I B B P B B...

== Advanced Codec Improvements (H.264/H.265)
- *Variable Macroblock Sizes*: H.264 allows macroblocks to be divided into smaller sub-blocks (e.g., $8 times 4$, $4 times 4$), allowing motion compensation to track finer details more accurately.
- *Quadtree Partitioning (H.265)*: H.265 replaces macroblocks with Coded Tree Units (CTUs) that can be recursively partitioned into smaller Coded Blocks (CBs) using a quadtree structure. This allows the block size to adapt to the complexity of the content within the frame.
- *Advanced Spatial Prediction*: In addition to temporal prediction, H.264/H.265 use multiple modes for spatial (intra-frame) prediction, where a block is predicted from its already coded neighbors within the same frame.
- *Advanced Transform*: H.264 uses a smaller, integer-based DCT-like transform ($4 times 4$), which reduces blocking and ringing artifacts. H.265 supports transforms of various sizes.
