% Upper-level interface demo, illustrates pre-processing of acquisitions,
% reconstructing images and post-processing them.

set_up_mr

try
    % acquisitions will be read from this HDF file
    input_data = AcquisitionData('simulated_MR_2D_cartesian.h5');
    
    % pre-process acquisition data
    fprintf('processing acquisitions...\n')
    processed_data = preprocess_acquisitions(input_data);
	
    % perform reconstruction
    recon = SimpleReconstruction();
    recon.set_input(processed_data)
    fprintf('reconstructing...\n')
    recon.process()
    images = recon.get_output();
    
    % plot obtained images
    data = abs(images.as_array());
    data = data/max(max(max(data)));
    dim = size(data);
    for i = 1 : dim(3)
        figure(i)
        imshow(data(:,:,i))
    end
    
catch err
    % display error information
    fprintf('%s\n', err.message)
    fprintf('error id is %s\n', err.identifier)
end
