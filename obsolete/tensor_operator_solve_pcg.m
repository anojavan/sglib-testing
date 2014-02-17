function [X,flag,info]=tensor_operator_solve_pcg( A, F, varargin )

%% parse options
options=varargin2options( varargin );
[M,options]=get_option( options, 'M', [] );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );

[trunc.eps,options]=get_option( options, 'eps', 0 );
[trunc.k_max,options]=get_option( options, 'k_max', 1000 );
[trunc.trunc_mode,options]=get_option( options, 'trunc_mode', 2 );
[trunc.vareps,options]=get_option( options, 'vareps', false );
[trunc.relcutoff,options]=get_option( options, 'relcutoff', true );
[trunc.vareps_threshold,options]=get_option( options, 'vareps_threshold', 0.1 );
[trunc.vareps_reduce,options]=get_option( options, 'vareps_reduce', 0.1 );
[trunc.show_reduction,options]=get_option( options, 'show_reduction', false );

check_unsupported_options( options, mfilename );

%% options to just pass on to the solver
pass_options={...
    'abstol', abstol,...
    'reltol', reltol,...
    'maxiter', maxiter,...
    'trunc', trunc, ...
    };

%% generate tensor prod preconditioner 
if ~isempty(M)
    if isempty(Minv)
        Minv=stochastic_precond_mean_based( M );
    else
        error( 'M and Minv cannot be specified both' );
    end
end
pass_options=[pass_options {'Minv', Minv}];


%% generate truncation options
% needs to become more intelligent
% pcg needs to pass stats to truncate function


trunc_med=trunc;
trunc_med.eps=trunc.eps/3;
trunc_med.k_max=1.5*trunc.k_max;

truncate_strong={@ctensor_truncate_variable, {trunc}, {2}};
truncate_med={@ctensor_truncate_fixed, {trunc_med}, {2}};
truncate_zero={@ctensor_truncate_zero, {trunc}, {2}};

if is_ctensor(F)
    switch trunc.trunc_mode
        case 1 % after preconditioning
            pass_options=[pass_options {'trunc_mode', 'after'}];
        case 2 % before preconditioning
            pass_options=[pass_options {'trunc_mode', 'before'}];
        case 3 % in the operator
            pass_options=[pass_options {'trunc_mode', 'operator'}];
    end
    %pass_options=[pass_options {'truncate_operator_func', truncate_operator_func}];
    %pass_options=[pass_options {'truncate_before_func', truncate_before_func}];
    %pass_options=[pass_options {'truncate_after_func', truncate_after_func}];

    %pass_options=[pass_options {'truncate_func', truncate_func}]
    %pass_options=[pass_options {'truncate_zero_func', truncate_zero_func}];
end

%% call pcg
[X,flag,info]=generalised_solve_pcg( A, F, pass_options{:} );


