#import "../definitions.typ": *

#pagebreak()

= Lossless Image Compression

== Image File Formats

Digital images can be broadly categorized into:
- *Raster (Bitmap) Images*: Composed of a grid of pixels, where each pixel stores color information. Examples include photographs and scanned documents.
- *Vector Images*: Defined by mathematical equations representing lines, curves, and shapes. Scalable without loss of quality. Examples include logos and illustrations.

=== Color Spaces
Color spaces define how colors are represented numerically. Common ones include:
- *RGB (Red, Green, Blue)*: An additive color model used for displays (monitors, TVs). Each color component (R, G, B) typically ranges from 0 to 255.
- *CMY(K) (Cyan, Magenta, Yellow, Key/Black)*: A subtractive color model used for printing.
- *HSV (Hue, Saturation, Value)*: Represents colors in terms of their hue (dominant color), saturation (purity), and value (brightness).
- *YUV (YIQ, YCbCr)*: Separates luminance (brightness, Y) from chrominance (color information, U/V or Cb/Cr), commonly used in video systems.

=== Representation of Bitmap Images
- *Monochrome*: 1 bit per pixel (black or white).
- *Shades of Gray (Grayscale)*: Typically 8 bits per pixel (256 shades of gray).
- *Color*: Each pixel is represented by a combination of color components (e.g., (R,G,B)).
- *Alpha Channel*: An additional channel often used to represent transparency information.

=== Color Palettes
For images with a limited number of colors, a color palette (or indexed color) can be used:
- A *conversion table* (palette) stores a set of distinct colors (e.g., 256 colors for an 8-bit palette).
- Each pixel then stores an index (pointer) into this table, rather than the full color value.
- *Grayscale*: A palette consisting only of shades of gray.
- *Pseudocolor*: A color palette where pixels point to full RGB colors.
- *Direct Color*: Each pixel directly stores its color values (e.g., 24-bit RGB).

== Lossless Compression of Raster Images

Lossless compression techniques for images aim to reduce file size without any loss of quality or information.

=== GIF (Graphics Interchange Format)
- GIF was developed by CompuServe in 1987.
- *Usage*: Best suited for sharp-edged line art, logos, and small animations with a limited number of colors. Not ideal for photographs.
- *Properties*:
  - Supports a color palette of up to 256 colors (from a 24-bit RGB space).
  - Can store multiple images in one file, enabling simple animations.
  - Features an *interlacing scheme* for progressive display during transmission.
  - Can embed textual information and control elements for animation delays.
- *Compression Method*: Uses LZW-based compression.
  - The dictionary size depends on the bits per pixel, typically $2^(b+1)$ to $2^(12)$.
  - Pointers (indices to the dictionary) are encoded with increasing length.
  - Data is organized into blocks, with special codes for end-of-block and end-of-file.

=== PNG (Portable Network Graphics)
- PNG was developed as a non-patented alternative to GIF, especially after Unisys began enforcing its LZW patent in the mid-1990s.
- *Properties*:
  - Supports a wide range of color depths: grayscale (1,2,4,8,16 bits), true color (24-bit RGB or 48-bit RGBA), and palette-indexed color (1,2,4,8 bits).
  - Includes full alpha channel support for sophisticated transparency.
  - Designed for network transmission, but does not support CMYK color space directly (not for print).
  - Employs a 2D interlacing scheme (Adam7 algorithm) for progressive display.
  - Primarily for single images; animations are supported by extensions like MNG and APNG.

=== PNG Compression
PNG compression proceeds in two main phases:
1. *Preprocessing (Filtering)*: This is a crucial step for decorrelating pixel values, making them more compressible. It applies a *model of linear prediction* to predict the value of each pixel based on its neighbors. The *difference* between the actual and predicted value (the prediction error) is then encoded.
  - *None*: No prediction, raw pixel values.
  - *Sub*: Predicts the current pixel value as the value of the pixel to its left: $I'(i,j) = I(i,j-1)$.
  - *Up*: Predicts as the value of the pixel above: $I'(i,j) = I(i-1,j)$.
  - *Average*: Predicts as the average of the left and upper pixels: $I'(i,j) = floor((I(i,j-1) + I(i-1,j))/2)$.
  - *Paeth*: A more sophisticated predictor (Alan W. Paeth, 1991) that selects the neighbor (left, above, or upper-left) whose value is closest to $a+b-c$, where $a$ is the left, $b$ is the above, and $c$ is the upper-left pixel. Each line can use a different filter method.
2. *Dictionary Compression*: The filtered (prediction error) data is then compressed using the Deflate algorithm (a combination of LZ77 and Huffman coding).
