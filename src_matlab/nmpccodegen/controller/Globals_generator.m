classdef Globals_generator
    %GLOBALS_GENERATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        location_globals
    end
    
    methods
        function obj = Globals_generator( location_globals)
            obj.location_globals=location_globals;
        end
        function generate_globals(obj,nmpc_controller)
            disp('Generating globals file at: '+obj.location_globals);
            obj.init_globals_file();
            
            obj.generate_title('Problem specific definitions');
            obj.define_variable('DIMENSION_INPUT', num2str(nmpc_controller.model.number_of_inputs));
            obj.define_variable('DIMENSION_STATE', num2str(nmpc_controller.model.number_of_states));
            obj.define_variable('DIMENSION_PANOC', num2str(nmpc_controller.dimension_panoc));
            obj.define_variable('MPC_HORIZON', num2str(nmpc_controller.horizon));

            obj.define_variable('NUMBER_OF_OBSTACLES', ...
                num2str(nmpc_controller.get_number_of_obstacles()) );
            obj.define_variable('DEFAULT_OBSTACLE_WEIGHT', num2str(1));
            obj.set_data_type(nmpc_controller.data_type);

            obj.generate_title('lbgfs solver definitions');
            obj.define_variable('LBGFS_BUFFER_SIZE',num2str(nmpc_controller.lbgfs_buffer_size));

            obj.generate_title('NMPC-PANOC solver definitions');
            obj.define_variable('PANOC_MAX_STEPS',num2str(nmpc_controller.panoc_max_steps));
            obj.define_variable('PANOC_MIN_STEPS',num2str(nmpc_controller.panoc_min_steps));
            

            
        end
        function init_globals_file(obj)
            fid = fopen(obj.location_globals,'w');

            date_string = ['/* file generated on ' datestr(datetime('now')) ' in Matlab */ \n'];
            fprintf(fid,date_string);
            
            fclose(fid);
        end
        function define_variable(obj,variable_name,variable_value)
            fid = fopen(obj.location_globals,'a');

            lines = ['#define ' variable_name ' ' variable_value '\n'];
            fprintf(fid,lines);
      
        end
        function generate_comment(obj,comment)
            fid = fopen(obj.location_globals,'a');

            fprintf(fid,"/* "+comment+" */ \n");

            fclose(fid);
        end
        function generate_title(obj,title)
            fid = fopen(obj.location_globals,'a');

            fprintf(fid,['/*' '\n' '* ---------------------------------' '\n']);
            fprintf(fid,['* ' , title , '\n']);
            fprintf(fid,['* ---------------------------------' '\n' '*/' '\n']);

            fclose(fid);
        end
        function set_data_type(obj,data_type)
            if(strcmp(data_type,'single precision'))
                obj.generate_title('constants used with float data type')
                obj.define_variable('real_t','float')
                obj.generate_comment('data types have different absolute value functions')
                obj.define_variable('ABS(x)', 'fabsf(x)')
                obj.generate_comment('Machine accuracy of IEEE float')
                obj.define_variable('MACHINE_ACCURACY', 'FLT_EPSILON')
                obj.generate_comment('large number use with things like indicator functions')
                obj.define_variable('LARGE', '100000')
            elseif(strcmp(data_type,'double precision'))
                obj.generate_title('constants used with double data type')
                obj.define_variable('real_t', 'double')
                obj.generate_comment('data types have different absolute value functions')
                obj.define_variable('ABS(x)', 'fabs(x)')
                obj.generate_comment('Machine accuracy of IEEE double')
                obj.define_variable('MACHINE_ACCURACY', 'DBL_EPSILON')
                obj.generate_comment('large number use with things like indicator functions')
                obj.define_variable('LARGE', '10000000000')
            else
                disp("Error: invalid data type, not supported by globals generator")
            end
        end
    end
    
end