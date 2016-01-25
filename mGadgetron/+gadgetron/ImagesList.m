classdef ImagesList < handle
    properties
        handle_
        name_
    end
    methods
        function self = ImagesList(images)
            self.name_ = 'ImagesList';
            if nargin < 1
                self.handle_ = calllib('mgadgetron', 'mNewObject', self.name_);
            else
                self.handle_ = calllib('mgadgetron', 'mCopyOfObject', images.handle_);
            end
            gadgetron.checkExecutionStatus(self.name_, self.handle_);
        end
        function delete(self)
            if ~isempty(self.handle_)
                calllib('mgadgetron', 'mDeleteObject', self.handle_)
            end
        end
        function write(self, file, group)
            handle = calllib('mgadgetron', 'mGT_writeImages', ...
                self.handle_, file, group);
            gadgetron.checkExecutionStatus(self.name_, handle);
            calllib('mgadgetron', 'mDeleteDataHandle', handle)
        end
        function data = image_as_array(self, im_num)
            ptr_i = libpointer('int32Ptr', zeros(3, 1));
            calllib...
                ('mgadgetron', 'mGT_getImageDimensions', ...
                self.handle_, im_num, ptr_i);
            dim = ptr_i.Value;
            n = dim(1)*dim(2)*dim(3);
            ptr_v = libpointer('doublePtr', zeros(n, 1));
            calllib...
                ('mgadgetron', 'mGT_getImageDataAsDoubleArray', ...
                self.handle_, im_num, ptr_v)
            data = reshape(ptr_v.Value, dim(1), dim(2), dim(3));
        end
    end
end