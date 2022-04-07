classdef Config_main
    properties
        config_main_filname = 'config_main.cfg';
        del_opt = 1;
        input_opt = 1;
        target_num = 1;
        passive = 'P'
        ssp = 'M';
        pekssp = -1;
        depth = 5000;
        ssp_suffix = 'munk';
        array_mode = 'S';
        rd = -1;
        fs;
        sim_time;
        rays_mode = 2;
        output_opt = 'RD';
        outputname = 'data.mat';
        array_loc = [0,0,0];
    end
    methods
        function write_config(self)
            fid = fopen(self.config_main_filname,'w+');
            fprintf(fid,self.config_main_filname);
            if ~strcmp('config_main.cfg',self.config_main_filname)
                fclose(fid);
                fid = fopen('config_main.cfg','w+');
                fprintf(fid,'config_main.cfg');
            end
            if self.del_opt == 1
                fprintf(fid,' D');
            else
                fprintf(fid,' N');
            end
            if self.input_opt == 1
                fprintf(fid,'M');
            end
            fprintf(fid,'\r\n');
            fprintf(fid,[num2str(self.target_num) , ' ' , self.passive]);
            fprintf(fid,'\r\n');
            fprintf(fid,[self.ssp , ' ' , num2str(self.depth)]);
            if self.ssp == 'C'
                fprintf(fid,[' ' , self.ssp_suffix]);
            end
            fprintf(fid,'\r\n');
            fprintf(fid,self.array_mode);
            if self.array_mode == 'S'
                fprintf(fid,[' ' , num2str(self.rd)]);
            end
            fprintf(fid,'\r\n');
            fprintf(fid,string(self.fs));
            fprintf(fid,'\r\n');
            fprintf(fid,string(self.sim_time));
            fprintf(fid,'\r\n');
            fprintf(fid,string(self.rays_mode));
            fprintf(fid,'\r\n');
            fprintf(fid,string(self.output_opt));
            if self.output_opt(2) == 'M' || self.output_opt(2) == 'Q'
                fprintf(fid,[' ' , self.outputname]);
            end
            fclose(fid);
        end
    end
end