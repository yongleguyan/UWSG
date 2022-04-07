try
    data = load('data.mat','data','fs');
end
global global_rays_mode plot_rd global_sd global_startx global_starty global_ssp global_plot_rays;
if isfield(data,'data')
    if global_plot_rays
        figure;
        ssize = get(0,'ScreenSize');
        set(gcf,'Position',[0.225 * ssize(3) 0.4 * ssize(4) 0.55 * ssize(3) 0.4 * ssize(4)]);
        subplot(1,2,1);
        fs = data.fs;
        data = data.data;
        plot((0:(size(data,2) - 1)) / fs,real(data(1,:)));
        title('Receiver 1');
        xlabel('t / s');
        set(gca,'Fontsize',14);
        set(gca,'Position',[.06 .17 .36 .74]);

        subplot(1,2,2);
        plot([0,15000],[0,0],'b');hold on;
        plot([0,15000],[5020,5020],'b','LineWidth',3);hold off;
        set(gca,'ylim',[-20,5050]);
        set(gca,'xlim',[0,15000]);
        set(gca,'YDir','Reverse');
        title('声线图计算中……');
        xlabel('Range / m');ylabel('Depth / m');
        set(gca,'Fontsize',14);
        set(gca,'Position',[.55 .17 .40 .74]);
        load('ssps.mat');
        switch global_ssp
            case 1
                ssp_munk = munk;
            case 2
                ssp_munk = munki;
            case 3
                ssp_munk = munkp;
            case 4
                ssp_munk = iso;       
        end
        sd_transfer = [5,20,50,100,150,200];
        bh = Bellhop_Config_RAP();
        bh.ssp = ssp_munk;
        bh.RD = plot_rd;
        bh.SD = sd_transfer(global_sd(1));
        bh.ZBOX = 4500 + 300 * global_rays_mode; 
        bh.RR = sqrt(global_startx(1) ^ 2 + global_starty(1) ^ 2);
        bh.run();
        fid = fopen('bh.ray','r');
        fgetl(fid);
        fscanf(fid,'%f',4);
        fscanf(fid,'%i',2);
        fscanf(fid,'%f',2);
        fgetl(fid);fgetl(fid);
        rmax = 50;
        while 1
            fscanf(fid,'%f',1);
            nsteps = fscanf(fid,'%i',1);
            NumTopBnc = fscanf(fid,'%i',1);
            NumBotBnc = fscanf(fid,'%i',1);
            if isempty(nsteps)
                break;
            end
            ray = fscanf(fid,'%f',[2 nsteps]);
            if NumBotBnc <= 1
                x = ray(1,:);z = ray(2,:);
                if z(end) - z(nsteps - 1) > 0
                    for i_nstep = 1 : (nsteps - 2)
                        if z(nsteps - i_nstep) - z(nsteps - i_nstep - 1) <= 0
                            break;
                        end
                    end
                else
                    for i_nstep = 1 : (nsteps - 1)
                        if z(nsteps - i_nstep) - z(nsteps - i_nstep - 1) >= 0
                            break;
                        end
                    end
                end
                while 1
                    if x(nsteps - i_nstep + 1) - x(nsteps - i_nstep) > 1e-3
                        break;
                    else
                        i_nstep = i_nstep - 1;
                    end
                end
                z_eigen = interp1(x((nsteps - i_nstep):end),z((nsteps - i_nstep):end),bh.RR);
                if abs(z_eigen - bh.RD) < 20
                    plot(x,z,'k','LineWidth',1.5);hold on;
                    if ray(1,end) > rmax
                        rmax = ray(1,end);
                    end
                end
            end
        end
        fclose(fid);
        set(gca,'xlim',[0,rmax]);
        plot([0,rmax],[0,0],'b');
        plot([0,rmax],[5020,5020],'b','LineWidth',3);
        plot(0,bh.SD,'ro');plot(bh.RR,bh.RD,'ro');
        if global_rays_mode == 1
            set(gca,'ylim',[-20,4500]);
        else
            set(gca,'ylim',[-20,5050]);
        end
        title('特征声线 - Bellhop');
        xlabel('Range / m');ylabel('Depth / m');
        set(gca,'YDir','Reverse');
        set(gca,'Fontsize',14);
        clearvars;
        try
            delete('bh.env');delete('bh.prt');delete('bh.ray');
        end
    else
        figure;
        ssize = get(0,'ScreenSize');
        set(gcf,'Position',[0.325 * ssize(3) 0.4 * ssize(4) 0.35 * ssize(3) 0.4 * ssize(4)]);
        fs = data.fs;
        data = data.data;
        plot((0:(size(data,2) - 1)) / fs,real(data(1,:)));
        title('Receiver 1');
        xlabel('t / s');
        set(gca,'Fontsize',14);
        clearvars;
    end
else
    clearvars;
end
