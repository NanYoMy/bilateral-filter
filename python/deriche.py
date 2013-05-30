__author__ = 'ostrodmit'
from math import exp

from scipy import ndimage
from scipy import misc

from numpy import ndarray

# misc.imsave('./lena.png', lena) # uses the Image module (PIL)
# blurred_lena = ndimage.gaussian_filter(lena, sigma=3)
# misc.imsave('./blurred_lena.png', blurred_lena) # uses the Image module (PIL)

# import matplotlib.pyplot as plt
# plt.imshow(l)
# plt.show()

def treat(image, k, a, b, c):

    (n, m) = image.shape

    out1 = ndarray(shape = (n,m), dtype=float)
    out2 = ndarray(shape = (n,m), dtype=float)

    # from left to right
    for i in range(n):
        for j in range(m):
            if j > 1:
                out1[i,j] = a[0] * image[i,j] + a[1] * image[i,j-1] + b[0] * out1[i,j-1] + b[1] * out1[i,j-2]
            if j == 0:
                out1[i,j] = a[0] * image[i,j]
            if j == 1:
                out1[i,j] = a[0] * image[i,j] + a[1] * image[i,j-1] + b[0] * out1[i,j-1]

    # from right to left
    for i in range(n):
        for j in reversed(range(m)):
            if j < m-2:
                out2[i,j] = a[2] * image[i,j+1] + a[3] * image[i,j+2] + b[0] * out2[i,j+1] + b[1] * out2[i,j+2]
            if j == m-1:
                pass
            if j == m-2:
                out2[i,j] = a[2] * image[i,j+1] + b[0] * out2[i,j+1]
    return (out1 + out2) * c


def deriche_filter(image, alpha):

    (n, m) = image.shape
    print('Deriche-filtering image ' +  str(n) + 'x' + str(m) + ' with alpha = ' + str(alpha))

    # Initialize parameters for smoothing mode
    k = ((1.0 - exp(-alpha)) ** 2.0) / (1.0 + 2.0 * alpha * exp(-alpha) - exp(-2.0 * alpha))

    a = [0 for i in range(8)]
    a[0] = k
    a[1] = k * exp(-alpha) * (alpha - 1)
    a[2] = k * exp(-alpha) * (alpha + 1)
    a[3] = -k * exp(-2.0 * alpha)
    for i in range(4):
        a[i+4] = a[i]

    b = [0, 0]
    b[0] = 2.0 * exp(-alpha)
    b[1] = -exp(-2.0 * alpha)

    c = [0, 0]
    c[0] = 1.0
    c[1] = 1.0

    temp = treat(image, k, a[:4], b, c[0])
    return treat(temp.transpose(), k, a[4:], b, c[1]).transpose()

def main():
    lena = misc.lena()
    for alpha in [0.1, 0.25, 0.5, 1, 2]:
        dericheLena = deriche_filter(lena, alpha)
        misc.imsave('./deriche_lena_' + str(alpha) + '.png', dericheLena)

if  __name__ =='__main__':main()
