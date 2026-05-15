use strict;
use warnings;
use Test::More;
use File::Spec::Functions qw( catfile );
use Test::Vars;

my $file = catfile( qw| t lib MyMod.pm | );
ok(-f $file, "Located dummy file for testing");

vars_ok $file;

done_testing;

__END__

This is the error output emitted.  We expect this output so we should be able
to find it in examining $@.

#   Failed test 't/lib/MyMod.pm'
#   at t/11_unused-gh-43.t line 10.
# checking MyMod in MyMod.pm ...
# $unused_c is used once in &MyMod::unpack_args at t/lib/MyMod.pm line 6

However, per report from Olaf Alders in
https://github.com/houseabsolute/p5-Test-Vars/issues/43#issuecomment-4464211367,
that's not all we reasonable expect in the error output, since there are two
*other* unused variables in MyMod::unpack_args(): $unused_a and $unused_b.

sub unpack_args {
    my ($used, $unused_a, $unused_b, $unused_c) = @_;
    return $used;
}

The defect discussed in gh #43 is that *only the last* in a sequence of unused
variables is reported by vars_ok().

