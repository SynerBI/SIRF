function acquisition_data(engine)
% A demo showing basics of PET acquisition data handling.

% SyneRBI Synergistic Image Reconstruction Framework (SIRF).
% Copyright 2015 - 2019 Rutherford Appleton Laboratory STFC.
% Copyright 2015 - 2019 University College London.
% 
% This is software developed for the Collaborative Computational
% Project in Synergistic Reconstruction for Biomedical Imaging (formerly CCP PETMR)
% (http://www.ccpsynerbi.ac.uk/).
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% http://www.apache.org/licenses/LICENSE-2.0
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

if nargin < 1
    engine = [];
end
% import_str = set_up_PET(engine);
% eval(import_str)
PET = set_up_PET(engine);
pet_data_path = sirf.Utilities.examples_data_path('PET');

% all acquisition data generated by this script will be stored in memory
% (the input data remain in the input file);
% default storage scheme 'file' keeps all acquisition data generated by
% the script in scratch files deleted after the script terminates
AD = PET.AcquisitionData();
scheme = AD.get_storage_scheme();
AD.set_storage_scheme('memory');
% scheme = AcquisitionData.get_storage_scheme();
% AcquisitionData.set_storage_scheme('memory');

try
    % select acquisition data to test
    [filename, pathname] = uigetfile...
        ('*.hs', 'Select raw data file', pet_data_path);
    acq_data = PET.AcquisitionData(fullfile(pathname, filename));
    fprintf('data dimensions: %d x %d x %d x %d\n', acq_data.dimensions())

    % copy the acquisition data into a Matlab array
    acq_array = acq_data.as_array();
    
    s = sqrt(acq_data*acq_data);
    fprintf('norm(acq_data): %e = %e = %e\n', ...
        acq_data.norm(), norm(acq_array(:)), s)

    acq_dim = size(acq_array);
    x = acq_dim(1)/2;
    y = acq_dim(2)/2;
    z = uint16(acq_dim(3)/2);

    % display the acquisition data
    sirf.Utilities.show_2D_array(acq_array(:,:,z), ...
        'acquisition data', 'tang. pos.', 'views');

    % rebin the acquisition data
    new_acq_data = acq_data.rebin(3);
    fprintf('rebinned data dimensions: %d x %d x %d x %d\n', ...
        new_acq_data.dimensions())

    % display the rebinned data
    acq_array = new_acq_data.as_array();
    sirf.Utilities.show_2D_array(acq_array(:,:,z), ...
        'acquisition data rebinned', 'tang. pos.', 'views');

    % clone the acquisition data
    new_acq_data = acq_data.clone();
    
    diff = new_acq_data - acq_data;
    fprintf('norm(new_acq_data - acq_data): %e\n', diff.norm())

    % display the cloned data
    acq_array = new_acq_data.as_array();
    sirf.Utilities.show_2D_array(acq_array(:,:,z), ...
        'acquisition data cloned', 'tang. pos.', 'views');

    % fill the cloned data with the acquisition data multiplied by 10
    % and see the difference at (x, y, z)
    fprintf('acq_data at (%d,%d,%d): %f\n', x, y, z, acq_array(x, y, z))
    new_acq_data.fill(10*acq_array)
    acq_array = new_acq_data.as_array();
    fprintf('new_acq_data at (%d,%d,%d): %f\n', x, y, z, acq_array(x, y, z))
    
    new_acq_data = acq_data*10;
    acq_array = new_acq_data.as_array();
    fprintf('acq_data*10 at (%d,%d,%d): %f\n', x, y, z, acq_array(x, y, z))
    
    image = acq_data.create_uniform_image(1.0);
    geom_info = get_geometrical_info(image);
    fprintf(geom_info.get_info())
    image_array = image.as_array();
    s = sqrt(image*image);
    fprintf('norm(image): %e = %e = %e\n', norm(image_array(:)), image.norm(), s)
    new_image = image.clone();
    diff = new_image + image*(-1);
    fprintf('norm(new_image - image): %e\n', diff.norm())
    new_image = image*10;
    fprintf('norm(image*10): %e\n', new_image.norm())
    new_image.fill(image);
    diff = new_image - image;
    fprintf('norm(new_image.fill(image) - image): %e\n', diff.norm())
    
catch err
    % display error information
    fprintf('??? %s\n', err.message)
    fprintf('error id is %s\n', err.identifier)
end
% Restore previous storage scheme
AD.set_storage_scheme(scheme);
%AcquisitionData.set_storage_scheme(scheme);
end
