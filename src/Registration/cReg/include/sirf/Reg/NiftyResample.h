/*
CCP PETMR Synergistic Image Reconstruction Framework (SIRF)
Copyright 2017 - 2019 University College London

This is software developed for the Collaborative Computational
Project in Positron Emission Tomography and Magnetic Resonance imaging
(http://www.ccppetmr.ac.uk/).

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

/*!
\file
\ingroup Registration
\brief Resampling class based on nifty resample

\author Richard Brown
\author CCP PETMR
*/

#pragma once

#include <nifti1_io.h>
#include <string>
#include <vector>
#include <iostream>
#include "sirf/Reg/Resample.h"

namespace NiftyMoMo {
class BSplineTransformation;
}

namespace sirf {

/*!
\ingroup Registration
\brief Resampling class based on nifty resample

The reference image and floating image can have nt and/or nu != 1.

\author Richard Brown
\author CCP PETMR
*/
template<class dataType>
class NiftyResample : public Resample<dataType>
{
public:

    /// Constructor
    NiftyResample() {}

    /// Destructor
    virtual ~NiftyResample() {}

    /// Process
    virtual void process();

    /// Get output (as NiftiImageData)
    const std::shared_ptr<const NiftiImageData<dataType> > get_output_as_niftiImageData_sptr() const { return _output_image_nifti_sptr; }

protected:

    /// Set up
    virtual void set_up();

    /// Set up forward
    virtual void set_up_forward();

    /// Set up adjoint
    virtual void set_up_adjoint();

    /// Set up the input images (convert from ImageData to NiftiImageData if necessary)
    void set_up_input_images();

    /// Set up the output image
    void set_up_output_image(const std::shared_ptr<const NiftiImageData<dataType> > im_for_shape_sptr, const std::shared_ptr<const NiftiImageData<dataType> > im_for_metadata_sptr);

    /// Do transformation with NiftyReg
    void transformation_forward();

    /// Do adjoint transformation with NiftyMoMo
    void transformation_adjoint();

    /// Reference image as a NiftiImageData
    std::shared_ptr<const NiftiImageData<dataType> > _reference_image_nifti_sptr;
    /// Floating image as a NiftiImageData
    std::shared_ptr<const NiftiImageData<dataType> > _floating_image_nifti_sptr;
    /// Floating image as a NiftiImageData
    std::shared_ptr<NiftiImageData<dataType> >       _output_image_nifti_sptr;

    /// Deformation
    std::shared_ptr<NiftiImageData3DDeformation<dataType> > _deformation_sptr;
    /// Needed for the adjoint transformation
    std::shared_ptr<NiftyMoMo::BSplineTransformation> _adjoint_transformer_sptr;
    /// Adjoint reference weights
    std::shared_ptr<NiftiImageData<dataType> > _adjoint_input_weights_sptr;
    /// Adjoint output weights
    std::shared_ptr<NiftiImageData<dataType> > _adjoint_output_weights_sptr;
};
}
