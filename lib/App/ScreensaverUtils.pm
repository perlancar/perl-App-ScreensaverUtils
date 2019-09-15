package App::ScreensaverUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

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

1;
# ABSTRACT: CLI utilities related to screensaver

=head1 DESCRIPTION

This distribution contains the following CLI utilities related to screensaver:

# INSERT_EXECS_LIST
