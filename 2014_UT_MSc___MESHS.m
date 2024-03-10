function X=MESHS(NCASE)
% This Scripts Creates the Mesh Points
% Subroutine :::
%               POSITIONS.m
% help on
% loading Positions.m
[DX25 DX50 DX100 DX200 DX400 DX800 DX1600 ...
     DX1047 DX1057 DX1067 DX1087]=POSITIONS();
% Creating Mesh ...
X(1)=0;
    if NCASE==2
        for J=2:21
            X(J)=X(J-1) + DX50;
            % npts=131
        end
        for J=22:51
            X(J)=X(J-1)+DX100;
        end
        for J=52:91
            X(J)=X(J-1)+DX200;
        end
        for J=92:130
            X(J)=X(J-1)+DX400;
        end
    end
    if NCASE==6
        % npts=80;
        % npts=5;
        DXXP=1.0/(NPTS-1);
        for J=2:NPTS
            X(J)=X(J-1)+DXXP;
        end
    end
    if NCASE==4
        % npts=191;
        for J=2:21
            X(J)=X(J-1)+DX50;
        end
        for J=22:51
            X(J)=X(J-1)+DX100;
        end
        for J=52:91
            X(J)=X(J-1)+DX200;
        end
        for J=92:111
            X(J)=X(J-1)+DX400;
        end
        for J=112:190
            X(J)=X(J-1)+DX1600;
        end
    end
    if NCASE==3
        % NPTS = 261
        for J=2:41
            X(J)=X(J-1)+DX100;
        end
        for J=42:101
            X(J)=X(J-1)+DX200;
        end
        for J=102:181
            X(J)=X(J-1)+DX400;
        end
        for J=182:260
            X(J)=X(J-1)+DX800;
        end
    end
    if NCASE==5
        % NPTS = 521
        for J=2:81
            X(J)=X(J-1)+DX200;
        end
        for J=82:201
            X(J)=X(J-1)+DX400;
        end
        for J=202:361
            X(J)=X(J-1)+DX800;
        end
        for J=362:520
            X(J)=X(J-1)+DX1600;
        end
    end
    if NCASE==1047
        % NPTS = 131 and equally distributed mesh
        for J=2:130
            X(J)=X(J-1)+DX1047;
        end
    end
    if NCASE==1057
        % NPTS = 131
        for J=2:31
            X(J)=X(J-1)+DX1087;
        end
        for J=32:130
            X(J)=X(J-1)+DX1067;
        end
    end
end
% End of nested m-file.
    