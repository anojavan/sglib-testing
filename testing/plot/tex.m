function [dviout,errout,auxout]=tex(str,varargin)
% MATLAB supports TeX/LaTeX for displaying equations
% and other mathematical expressions in the MATLAB figure
% window.
%
% Example:
%
%   mytexstr = '$\frac{1}{2}$';
%   h = text('string',mytexstr,...
%            'interpreter','latex',...
%            'fontsize',40,...
%            'units','norm',...
%            'pos',[.5 .5]);
%
% The MATLAB implementation of TeX is compiled from Donald Knuth's
% original TeX parser (version: 3.14159) located on the
% <a href="matlab: web('http://www.ctan.org')">TeX Archive Network</a>. The LaTeX distribution was also obtained
% from the TeX Archive Network.
%
% The True Type and Adobe Type 1 Computer Modern fonts were
% obtained from the BaKoMa Fonts Collection located on the
% TeX Archive Network:
% http://www.ctan.org/tex-archive/fonts/cm/ps-type1/bakoma
%
% The most recent and complete version of BaKoMa Fonts is
% available at:
% http://www.ctan.org/tex-archive/systems/win32/bakoma
%
% For more information on TeX & LaTeX, please see the following:
%    -<a href="matlab:web('http://www.tug.org')">TeX Users Group </a>
%    -<a href="matlab:web('http://www.ctan.org')">TeX Archive Network </a>
%    -Newsgroup: "comp.text.tex"
%
% This m-file is a helper function for generating "DVI", TeX's
% device independent typesetting code.

%TEX  Interpret a TeX or LaTeX string
%   DVI = TEX(STR) runs TeX or LaTeX on the string STR and returns the dvi
%   output in Y as a uint8 vector.
%
%   DVI = TEX(...,PARAM1,VAL1,PARAM2,VAL2,...) applies the parameter-value
%   pairs. Legal PARAM strings are
%      'format'   ['latex'], 'plain'  - specify format of STR
%      'width'    Turn on line-wrapping to the width VAL. The string VAL must
%                 contain a legal TeX dimension expression (eg, '4in').
%                 If line-wrapping is turned off then using '$$' for display
%                 math mode will be replaced with '$/displaystyle'
%      'fragment' false, [true]  - interpret STR as a content
%                 fragment within \begin{document} and \end{document}
%      'verbose'  [0],1,2,3 - print out debugging information.
%      'dofileio' true,[false] - print dvi & log output to a
%                 file. No arguments are returned.
%      'initex'   true,[false] - call initex parser instead of tex
%                 parser (initex is for building *.fmt files, see TeX
%                 reference for more information)
%
%   [DVI,ERR] = TEX(...) returns the error message generated by the TeX
%                parser.
%
%   [DVI,ERR,AUX] = TEX(...) returns in AUX any auxiliary output
%                generated by TeX as a cell array of output
%                name and contents pairs.
%
%   TEX('addpath',DIR) adds DIR to the TeX search path.
%
%  The LaTeX implementation does not contain T1 encoded Computer
%  Modern (dc & ec) fonts.

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 1.1.10.12 $  $Date: 2008/04/11 15:37:25 $

dvi = []; 
%err = []; 
loginfo = [];
dviout = []; errout = []; auxout = [];

% Syntax: tex('addtexpath',...)
if ischar(str) && strcmp(str,'addpath') && nargin==2 && ischar(varargin{1})
    pathCache = localGetTeXPath;
    pathCache{end+1} = varargin{1};
    setappdata(0,'TeXPath',pathCache);
    return;
end

% Syntax: tex(str,'param1','val1',...)
format = '%&latex'; %'%&plain';
width = [];
fragment = true;
verbose = 0;
dofileio = false;
doinitex = false;
%doincludelatex = false;
if nargin > 1
    while ~isempty(varargin)
        switch lower(varargin{1})
            case 'format'
                format = ['%&' varargin{2}];
            case 'width'
                width = varargin{2};
            case 'fragment'
                fragment = varargin{2};
            case 'verbose'
                verbose = varargin{2};
            case 'dofileio'
                dofileio = varargin{2};
            case 'initex'
                doinitex = varargin{2};
        end
        varargin(1:2) = [];
    end
end
verbose=true;
[err] = localCheckValidString(str);
if isempty(err)
    [tstr] = localDecorateInputString(str,format,width,fragment);
    [dvi,loginfo,err] = localCallTeXParser(tstr, doinitex, verbose, dofileio);
    %dvi=dvimod(dvi);
end

if nargout > 0
    % If error message exists, then force dvi to be empty
    if ~isempty(err)
        dviout = [];
    else
        %dviout = dvi;
        dviout = dvimod(dvi, 500000, false);
    end
    if nargout > 1
        errout = err;
    end
    if nargout > 2
        auxout = loginfo;
    end
end

%-------------------------------------------------------%
function [err] = localCheckValidString(str)

err = [];

if iscell(str)
    strchk = strcat(str{:});
else
    strchk = str;
end

% if ~isempty(find(strchk>char(126),1)) 
if ~isempty(find(strchk>char(126))) 
    err = 'Invalid text character detected.';
end

% The max buffer size in the TeX parser is 1500 characters, we
% can control this buffer size using tex.ch, but 1500 seems reasonable.
% This error will also get caught by texmex, but by catching the
% error before calling the TeX parser we can customize the error message.
if length(strchk)>1300
    err = 'TeX/LaTeX string is too long.';
end

%-------------------------------------------------------%
function [tstr] = localDecorateInputString(str,format,width,fragment)
% str is a cell array or char array

% Convert multi-line cell string to char array
% with the following format:
% \vbox{\hbox{str1}\hbox{str2}...}
if iscell(str)
    if numel(str)==1
        str = str{1};
    else
        strc = '\vbox{';
        for n = 1:length(str)
            strc = [strc,'\hbox{',str{n},'}'];
        end
        strc = [strc,'}'];
        str = strc;
    end
end

if strcmp(format(3:end),'latex')
    standardhead = ' \nofiles \documentclass{mwarticle} \begin{document}';
    standardtail = ' \end{document}';
else
    standardhead = ' \relax \nopagenumbers \noindent';
    standardtail = ' \bye';
end

if isempty(width)
    tstr = str(1);
    n=2;
    mathmode = 0;
    % replace $$ with $\displaystyle
    while n<=length(str)
        if (str(n) == '$') && (str(n-1) == '$')
            if ~mathmode
                tstr = [tstr '\displaystyle '];
            end
            n=n+1;
            mathmode = ~mathmode;
        else
            tstr = [tstr str(n)];
            n=n+1;
        end
    end

    if fragment
        tstr = [ format standardhead '\setbox0=\hbox{' tstr ...
            '}\copy0\special{bounds: \the\wd0 \the\ht0 \the\dp0}' ...
            standardtail];
    else
        % For now, let input string define format, this is used when
        % generating format files (i.e. plain.fmt)
        %  tstr = [ format ' ' tstr ];
    end
else
    if fragment
        tstr = [ format standardhead ' \hsize=' width ' \setbox0=\hbox{' str ...
            '}\copy0\special{bounds: \the\wd0 \the\ht0 \the\dp0}' ...
            standardtail];
    else
        tstr = [ format ' ' tstr ];
    end
end

%-------------------------------------------------------%
function [dvi,loginfo,err] = localCallTeXParser(tstr, doinitex, verbose, dofileio)

dvi = [];
loginfo = [];
%err = [];
[texpath,err] = localGetTeXPath;

try
    if isempty(err)
        % Send output to files
        if dofileio
            if doinitex
                mlinitex(tstr, texpath, verbose, dofileio);
            else
                texmex(tstr, texpath, verbose, dofileio);
            end
            % Send output to return variables
        else
            if doinitex
                [dvi,loginfo,err] = mlinitex(tstr, texpath, verbose, dofileio);
            else
                [dvi,loginfo,err] = texmex(tstr, texpath, verbose, dofileio);
            end
        end
    end
catch ex
    err = ex.getReport('basic'); 
    dvi = [];
    loginfo = [];
end

%-------------------------------------------------------%
function [texpath,err] = localGetTeXPath
% Create cell array containing directories

texpath = getappdata(0,'TeXPath');
err = [];

% Always reload search cache if calling initex since files may have changed
if isempty(texpath)
    mlroot = matlabroot;

    % Uncomment the following for sandbox testing
    %mlroot = 'S:/A/matlab';
    texpath = {};
    texpath{end+1} = fullfile(mlroot,'sys','fonts','ttf','cm',filesep);
    texpath{end+1} = fullfile(mlroot,'sys','fonts','type1','cm',filesep);
    texpath{end+1} = fullfile(mlroot,'sys','tex',filesep);
    texpath{end+1} = fullfile(mlroot,'sys','tex','latex','base',filesep);
    texpath{end+1} = fullfile(mlroot,'sys','tex','tfm',filesep);

    [c,maxsize,endian] = computer;
    if strncmp(endian,'B',1)
        texpath{end+1} = fullfile(mlroot,'sys','tex','format','bigendian',filesep);
    else
        texpath{end+1} = fullfile(mlroot,'sys','tex','format','smallendian',filesep);
    end

    % Error if directories don't exist
    for n = 1:length(texpath)
        if ~isequal(exist(texpath{n},'dir'),7)
            err = sprintf('Can''t find %s',texpath{n});
            break;
        end
    end

    % Cache path
    if isempty(err)
        setappdata(0,'TeXPath',texpath);
    end

    % Load fonts on Windows
    if ispc
        [names,paths] = localExpandDir(...
            fullfile(mlroot,'sys','fonts','type1','cm',filesep));
        localLoadType1FontsOnWindows(names,paths);
    end
end

%-------------------------------------------------------%
function localLoadType1FontsOnWindows(names,paths)
% Load all Type1 fonts. This function assumes that
% NAMES is already in alphabetical order

% TBD Replace this code with REGEXP

% Ignore files that don't have a .pfm or .pfb extension
ind = [];
for n = 1:length(names)
    tmp = fliplr(names{n});
    if strncmp(tmp,'bfp.',4) || strncmp(tmp,'mfp.',4)
        ind(end+1) = n;
    end
end
names = {names{ind}};
paths = {paths{ind}};

% Remove '.pfb' and '.pfm' extension to simplify comparison test
names = strrep(names,'.pfb','');
names = strrep(names,'.pfm','');

% Walk through list, concatenate .pfm and .pfb font files together
n = 1;
path_2_pfm_pfb_files = {};
while n<length(names)
    if strcmp(names{n},names{n+1})
        % Separate .pfm and .pfb file with a "|", this syntax is required
        % by Windows GDI AddFontResource function
        tmp = sprintf('%s|%s',paths{n+1},paths{n});
        tmp = strrep(tmp,'/','\');
        path_2_pfm_pfb_files{end+1} = tmp;
        n = n + 2;
    else

        n = n + 1;
    end
end

% Pass to mexfile for GDI loading
loadfonts(path_2_pfm_pfb_files);

%-------------------------------------------------------%
function [names,paths] = localExpandDir(root)

if ~exist(root,'dir')
%     message = sprintf('%s does not exist',root);
    error('MATLAB:graphics:tex','%s does not exist',root);
end

d = dir(root); % big performance hit
inds = find([d.isdir]);
list = {d(~logical([d.isdir])).name};
plist = cell(1,length(list));
for n=1:length(list)
    plist{n} = fullfile(root,list{n});
end

% recurse on sub-directories
% for n=inds
%   subd = d(n);
%   if ~(strcmp(subd.name,'.') || strcmp(subd.name,'..'))
%     [slist,splist] = localExpandDir(fullfile(root,subd.name));
%     list = {list{:}, slist{:}};
%     plist = {plist{:}, splist{:}};
%   end
% end

names = list;
paths = plist;
