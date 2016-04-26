import math
import os
import pylab
import sys
import time

BUILD_PATH = os.environ.get('BUILD_PATH') + '/xGadgetron'
SRC_PATH = os.environ.get('SRC_PATH') + '/xGadgetron/pGadgetron'

sys.path.append(BUILD_PATH)
sys.path.append(SRC_PATH)

from pGadgetron import *

try:
    # acquisitions will be read from this HDF file
    input_data = MR_Acquisitions('testdata.h5')

    # pre-process acquisition data
    print('processing acquisitions...')
    processed_data = MR_remove_x_oversampling(input_data)

    # perform reconstruction
    recon = MR_BasicReconstruction()
    recon.set_input(processed_data)
    print('reconstructing...')
    recon.process()
    complex_images = recon.get_output()

    # post-process reconstructed images
    print('processing images...')
    images = MR_extract_real_images(complex_images)

    # plot obtained images
    for i in range(images.number()):
        data = images.image_as_array(i)
        pylab.figure(i + 1)
        pylab.imshow(data[0,0,:,:])
        print('delete the plot window to continue...')
        pylab.show()

except error as err:
    # display error information
    print ('Gadgetron exception occured:\n', err.value)
