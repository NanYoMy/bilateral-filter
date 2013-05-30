__author__ = 'ostrodmit'
from math import exp

from scipy import ndimage
from scipy import misc

lena = misc.lena()
misc.imsave('./lena.png', lena) # uses the Image module (PIL)
blurred_lena = ndimage.gaussian_filter(lena, sigma=3)
misc.imsave('./blurred_lena.png', blurred_lena) # uses the Image module (PIL)

# import matplotlib.pyplot as plt
# plt.imshow(l)
# plt.show()

def deriche_filter(image, alpha):

    (n, m) = image.shape

    print('Deriche filtering image ' +  str(n) + 'x' + str(m))

    # Initialize parameters
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



deriche_filter(lena, 1)

