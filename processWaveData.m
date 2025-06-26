% Copyright (C) 2025 Eduardo Castro
% Author: Eduardo Castro <eduardocastro@MacBook-Air-de-Eduardo.local>
% Created: 2025-06-03

function [] = processWaveData(kappa, widths, angles, options)


% Set default parameter values
    if nargin < 4
        options = struct();
    end

    % Default graph parameters
    if nargin < 1 || isempty(kappa), kappa = 0.25; end
    if nargin < 2 || isempty(widths), widths = [1, 0.5, 0.5]; end
    if nargin < 3 || isempty(angles), angles = [0, 2*pi/3, 4*pi/3]; end

    % Default numerical parameters
    default_options = struct(...
        'plot_physical', false,...
        'plot_canonical', false,...
        'play_movie_phys', false,...
        'play_movie_canonical', true,...
        'save_video', false,...
        'jmp_xi', 1,...
        'jmp_zeta', 1,...
        'az',-20,...
        'el',40);
    

    % Merge user options with defaults
    option_names = fieldnames(default_options);
    for k = 1:length(option_names)
        if ~isfield(options, option_names{k})
            options.(option_names{k}) = default_options.(option_names{k});
        end
    end

    %% Load wave Graph
    ang_display = round(angles .* 1000) ./ 1000;
    data = load(['WaveData/kappa', num2str(kappa),'widths= ', mat2str(widths), 'angles= ', mat2str(ang_display), '.mat']);

    %%
    h = data.h;
    X1 = data.X1;
    X2 = data.X2;
    X3 = data.X3;
    Y1 = data.Y1;
    Y2 = data.Y2;
    Y3 = data.Y3;
    t = data.t;
    z = data.z;
    xi_lims = data.xi_lims;
    Xi = data.Xi;
    J = data.J;
    th_zeta = data.th_zeta;
    th_xi = data.th_xi;

    %%
    if options.plot_physical
    hh=h;

    jmp = 1;

    h1=hh(1:end,1:jmp:th_xi+1);
    h2=hh(1:th_zeta,th_xi-1:jmp:end);
    h3=hh(th_zeta+1:end,th_xi-1:jmp:end);

    XX1 = X1(1:end,1:jmp:end);
    YY1 = Y1(1:end,1:jmp:end);

    XX2 = X2(1:end,1:jmp:end);
    YY2 = Y2(1:end,1:jmp:end);

    XX3 = X3(1:jmp:end,1:jmp:end);
    YY3 = Y3(1:jmp:end,1:jmp:end);

    %subplot(1,2,1)
    mesh(XX1, YY1, h1, 'edgecolor', 'k'); hold on,
    mesh(XX2, YY2, h2, 'edgecolor', 'k');
    mesh(XX3, YY3, h3, 'edgecolor', 'k');
    hold off,
    view(options.az, options.el);
    zlim([-0.15,.2])
    %caxis([min(h(:)), max(h(:))]);  % Set the color axis limits based on the data range
    xlabel('X'); ylabel('Y'); zlabel('h');
    title(['Time evolution of wave profile = ',num2str(t)]);

    %subplot(1,2,2)
    %surf(Xi,Zeta,h)

    drawnow;
    end


    if options.plot_canonical
        %

        hh=h;

        h1=hh(:,1:th_xi);
        h2=hh(1:th_zeta,th_xi:end);
        h3=hh(th_zeta+1:end,th_xi:end);

        %subplot(1, 2, 1);
        %mesh(X1, Y1, h1, 'edgecolor', 'k'); hold on,
        %mesh(X2, Y2, h2, 'edgecolor', 'k');
        %mesh(X3, Y3, h3, 'edgecolor', 'k');

        %hold off,
        %
        %subplot(1, 2, 2);
        
        
        
        mesh(real(data.data.w),imag(data.data.w),h)
        zlim([-0.05,a])

        %set(gcf, 'Renderer', 'opengl');  % Better rendering quality
        %set(gca, 'FontSize', 14);        % Make axes labels crisper
        %shading interp                   % Smooth surface shading
        %lighting gouraud                 % Optional: if you use lighting

        drawnow;

    end
    
    
    %% Play movie and save video
    if options.play_movie_phys
        if options.save_video
            vwriter = VideoWriter(['Export/kappa',...
                num2str(kappa),'widths= ', mat2str(widths), 'angles= ', mat2str(ang_display), '.mp4'], 'MPEG-4');
            vwriter.FrameRate = 10;      % Adjust for desired smoothness
            vwriter.Quality = 100;       % Max quality (optional)
            open(vwriter);
        end
        

        mytitle = ['Angle = ', num2str(rad2deg(angles(3)-angles(2))), ' degrees'];

        tmp = size(data.H);
        
        
        figure
        %for i = 1:data.options.frames-2
        for i = 1:tmp(2)

            h = reshape(data.H(:,i),size(z));

            hh=h;

            jmp = options.jmp_xi;
            jmpz = options.jmp_zeta;
            
            ngrid = size(h);
            
            [Nzeta, Nxi] = deal(ngrid(1),ngrid(2));
            
            zindexes1 = [1:jmpz:th_zeta, th_zeta, th_zeta+1:jmpz:Nzeta];
            zindexes2 = [1:jmpz:th_zeta, th_zeta];
            %zindexes3 = th_zeta+1:jmpz:Nzeta;

            h1=hh(zindexes1,[1:jmp:th_xi,th_xi]);
            h2=hh(zindexes2,th_xi:jmp:end);
            h3=hh(th_zeta+1:jmpz:end,th_xi:jmp:end);

            XX1 = X1(zindexes1,[1:jmp:end, end]);
            YY1 = Y1(zindexes1,[1:jmp:end, end]);

            XX2 = X2(zindexes2,1:jmp:end);
            YY2 = Y2(zindexes2,1:jmp:end);

            XX3 = X3(1:jmpz:end,1:jmp:end);
            YY3 = Y3(1:jmpz:end,1:jmp:end);
            
            %% Debug
            %---------
            %h1 = zeros(size(h1));
            %h2 = zeros(size(h2));
            %---------
            mesh(XX1, YY1, h1, 'edgecolor', 'k'); hold on,
            mesh(XX2, YY2, h2, 'edgecolor', 'k');
            mesh(XX3, YY3, h3, 'edgecolor', 'k');   
            hold off,
            view(options.az, options.el);
            zlim([-0.02,.12])
            %caxis([min(h(:)), max(h(:))]);  % Set the color axis limits based on the data range
            xlabel('X'); ylabel('Y'); zlabel('h');
            %title(['Time evolution of wave profile = ',num2str(t)]);
            title(mytitle)
      

            pause(0.1)


            drawnow;
            
            if options.save_video
                %while counter/i < 10
                frame = getframe(gcf); % Capture current figure
                writeVideo(vwriter, frame); % Write frame to video
                %counter = counter + 1;
                %end
            end

        end

    end
    
    
    %% Animation in canonical coordinates
    if options.play_movie_canonical
        
        mytitle = ['Angle = ', num2str(rad2deg(angles(3)-angles(2))), ' degrees: Canonical domain'];
   
        figure

        %for i = 1:data.options.frames-2
        for i = 1:tmp(2)
        h = reshape(data.H(:,i),size(z));
            
        %hh=h;

        %h1=hh(:,1:th_xi+1);
        %h2=hh(1:th_zeta,th_xi-1:end);
        %h3=hh(th_zeta+1:end,th_xi-1:end);

        %subplot(1, 2, 1);
        %mesh(X1, Y1, h1, 'edgecolor', 'k'); hold on,
        %mesh(X2, Y2, h2, 'edgecolor', 'k');
        %mesh(X3, Y3, h3, 'edgecolor', 'k');

        %hold off,
        %
        %subplot(1, 2, 2);
        mesh(real(data.data.w),imag(data.data.w),h)
        zlim([-0.05,0.1])

        
        title(mytitle)
        drawnow;
        

        pause(0.1)
        end
        
    end
    
    
    if options.save_video
       close(vwriter)
    end


