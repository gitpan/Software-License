#!perl -T

use Test::More;
eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;
all_pod_coverage_ok({
  coverage_class => 'Pod::Coverage::CountParents',
  trustme => [ qw(meta_yml_name) ],
});
