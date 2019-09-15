package App::ScreensaverUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Screensaver::Any ();

our %SPEC;

$SPEC{prevent_screensaver_activated_while} = {
    v => 1.1,
    summary => 'Prevent screensaver activated while running a command',
    description => <<'_',

Uses <pm:Proc::Govern> to run a command, with the option `no-screensaver' to
instruct Proc::Govern to regularly simulate user activity, thus preventing the
screensaver from ever activating while running the command. For more options
when running command, e.g. timeout, load control, autorestart, use the module or
its CLI <prog:govproc> directly.

_
    args => {
        command => {
            schema => ['array*', of=>'str*'],
            req => 1,
            pos => 0,
            slurpy => 1,
        },
    },
};
sub prevent_screensaver_activated_while {
    require Proc::Govern;

    my %args = @_;

    my $exit = Proc::Govern::govern_process(
        command => $args{command},
        no_screensaver => 1,
    );

    [200, "Exit code is $exit", "", {"cmdline.exit_code"=>$exit}];
}

$SPEC{prevent_screensaver_activated_until_interrupted} = {
    v => 1.1,
    summary => 'Prevent screensaver activated until interrupted',
    description => <<'_',

Uses <pm:Proc::Govern> to run `sleep infinity`. To stop preventing screensaver
from sleeping, press Ctrl-C.

For more options when running command, e.g. timeout, load control, autorestart,
use the module or its CLI <prog:govproc> instead.

Available in CLI with two shorter aliases: <prog:pause-screensaver> and
<prog:noss>.

_
    args => {
    },
};
sub prevent_screensaver_activated_until_interrupted {
    require Proc::Govern;

    my %args = @_;

    my $exit = Proc::Govern::govern_process(
        command => ['sleep', 'infinity'],
        no_screensaver => 1,
    );

    [200, "Exit code is $exit", "", {"cmdline.exit_code"=>$exit}];
}

$SPEC{get_screensaver_info} = {
    v => 1.1,
    summary => 'Get screensaver information (detected screensaver, is_active, is_enabled, timeout)',
    args => {
        %Screensaver::Any::arg_screensaver,
    },
};
sub get_screensaver_info {
    my %args = @_;

    my %res;

    {
        if ($args{screensaver}) {
            $res{screensaver} = $args{screensaver};
        } else {
            last unless $res{screensaver} = Screensaver::Any::detect_screensaver();
        }

        my $res = Screensaver::Any::screensaver_is_enabled(%args);
        $res{is_enabled} = $res->[0] == 200 ? $res->[2] : undef;

        $res = Screensaver::Any::screensaver_is_active(%args);
        $res{is_active} = $res->[0] == 200 ? $res->[2] : undef;

        $res = Screensaver::Any::get_screensaver_timeout(%args);
        $res{timeout} = $res->[0] == 200 ? $res->[2] : undef;
    }

    [200, "OK", \%res];

}

1;
# ABSTRACT: CLI utilities related to screensaver

=head1 DESCRIPTION

This distribution contains the following CLI utilities related to screensaver:

# INSERT_EXECS_LIST
