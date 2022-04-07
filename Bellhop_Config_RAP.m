classdef Bellhop_Config_RAP
    properties
        title = 'bh';
        freq = 5000;
        nmedia = 1;
        TOPOPT = 'SVWT';
        NMESH = 0;
        TOPSIGMA = 0;
        DEPTH = 5000;
        ssp = [0,1500;5000,1500];
        BOTOPT = 'A';
        BOTSIGMA = 0;
        BOTTOM_PROP = [5000,1600,0.0,1.8,0.8,0.0];
        NSD = 1;
        SD = 100;
        NRD = 1;
        RD = 4000;
        NRR = 1;
        RR = 5;
        RUNOPT = 'E';
        NBEAMS = 20001;
        ALPHA = [-90,90];
        STEP = 0;
        PCS = 6;
        ZBOX = 4500;
        RBOX = 15;
    end
    methods
        function write_config(self)
            fid = fopen([self.title,'.env'],'w+');
            if fid == 0
                error('Error: Fail to create configuration file!');
            end
            fprintf(fid,'\''%s\'' \r\n',self.title);
            fprintf(fid,'%g \r\n', self.freq);
            fprintf(fid,'%d \r\n', self.nmedia);
            fprintf(fid,'\''%s\'' \r\n',self.TOPOPT);
            if self.DEPTH ~= self.ssp(end,1)
                error('Depth mismatched! Please modify the depth of the sound speed profile!\n');
            end
            fprintf(fid,'%d %g %g \r\n',self.NMESH,self.TOPSIGMA,self.DEPTH);
            for i_zssp = 1:size(self.ssp,1)
                fprintf(fid,'%.2f %.2f / \r\n',self.ssp(i_zssp,:));
            end
            fprintf(fid,'\''%s\'' %d \r\n',self.BOTOPT,self.BOTSIGMA);
            fprintf(fid,'%.2f  %.2f  %.2f  %.2f  %.2f  %.2f / \r\n',self.BOTTOM_PROP);
            fprintf(fid,'%d \r\n', self.NSD);
            if self.SD < 1e-4 || self.SD > 350
                error('Error: Source depth invalid.');
            end
            if self.NSD == 1
                fprintf(fid,'%g / \r\n',self.SD(end));
            else
                fprintf(fid,'0 %g / \r\n',self.SD(end));
            end
            fprintf(fid,'%d \r\n', self.NRD);
            if self.RD < 2999 || self.RD > 4501
                error('Error: Reveiver depth invalid.');
            end
            if self.NRD == 1
                fprintf(fid,'%g / \r\n', self.RD(end));
            else
                fprintf(fid,'0 %g / \r\n', self.RD(end));
            end
            fprintf(fid,'%d \r\n', self.NRR);
            if self.RR(end) < 49 || self.RR(end) > 18001
                error('Error: Reveiver range invalid.');
            end
            if self.NRR == 1
                fprintf(fid,'%g / \r\n', self.RR(end) / 1000);
            else
                fprintf(fid,'0 %g / \r\n', self.RR(end) / 1000);
            end
            fprintf(fid,'\''%s\'' \r\n',self.RUNOPT);
            fprintf(fid,'%d \r\n', self.NBEAMS);
            fprintf(fid,'%.7f %.7f / \r\n', self.ALPHA);
            if self.ZBOX < self.RD(end) || self.ZBOX < self.SD(end)
                self.ZBOX = 1.01 * max([self.RD(end),self.SD(end)]);
            end
            if self.RBOX < self.RR(end)
                self.RBOX = 1.01 * self.RR(end);
            end
            fprintf(fid,'%d %g %g', self.STEP,self.ZBOX,self.RBOX);
            fclose(fid);
        end
        function run(self)
            write_config(self);
            eval(['bellhop ',self.title]);
        end             
    end
end