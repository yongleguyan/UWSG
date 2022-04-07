classdef Target
    properties
        target_no = 0;
        sd;
        motion_mode = 0;
        startx = 0;
        starty = 0;
        speedx = 0;
        speedy = 0;
        speed_opt = 0;
        power = 1;
        fs;
        signal_mode = 0;
        signal_freq = 0;
        signal_bandwidth = 0;
        signal_cmode = 1;
        signal_cmodeb = 0;
    end
    methods
        function self = Target(target_no)
            self.target_no = target_no;
        end
        function write_config(self)
            target_filname = strcat('target',num2str(self.target_no),'.cfg');
            fid = fopen(target_filname,'w+');
            fprintf(fid,[num2str(self.sd) , ' ' , num2str(self.motion_mode)]);
            fprintf(fid,'\r\n');         
            fprintf(fid,[num2str(self.startx) , ' ' , num2str(self.starty)]);
            fprintf(fid,'\r\n');         
            fprintf(fid,[num2str(self.speedx), ' ' , num2str(self.speedy) , ' ' , num2str(self.speed_opt)]);
            fprintf(fid,'\r\n');
            fprintf(fid,string(self.power));
            fprintf(fid,'\r\n');
            fprintf(fid,string(self.fs));
            fprintf(fid,'\r\n');
            fprintf(fid,string(self.signal_mode));
            fprintf(fid,'\r\n');
            if self.signal_mode == 0 || self.signal_mode == 1 || self.signal_mode == 2
                fprintf(fid,string(self.signal_freq));
                if self.signal_mode == 1 || self.signal_mode == 2
                    fprintf(fid,[' ' , num2str(self.signal_bandwidth)]);
                end
            else
                if self.signal_mode == 3
                    fprintf(fid,string(self.signal_cmode));
                    if self.signal_cmode == 0
                        fprintf(fid,[' ' , num2str(self.signal_cmodeb)]);
                        fprintf(fid,'\r\n');
                        fprintf(fid,string(self.signal_freq));
                        if self.signal_cmodeb == 1 || self.signal_cmodeb == 2
                            fprintf(fid,[' ' , num2str(self.signal_bandwidth)]);
                        end
                    end
                end
            end
            fclose(fid);
        end
    end
end