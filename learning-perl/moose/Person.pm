package Person;

use Moose;

has 'name' => (is => 'rw');
has 'age' => (is => 'rw');

no Moose;

1;
