from production import IF, AND, OR, NOT, THEN, forward_chain

# You're given this data about poker hands:
poker_data = ( 'two-pair beats pair',
               'three-of-a-kind beats two-pair',
               'straight beats three-of-a-kind',
               'flush beats straight',
               'full-house beats flush',
               'straight-flush beats full-house' )

# Fill in this rule so that it finds all other combinations of
# which poker hands beat which, transitively. For example, it
# should be able to deduce that a three-of-a-kind beats a pair,
# because a three-of-a-kind beats two-pair, which beats a pair.
transitive_rule = IF( AND('(?x) beats (?y)',
                          '(?y) beats (?z)',
                          NOT ('(?z) beats (?x)')),
                      THEN('(?x) beats (?z)') )

# You can test your rule like this:
print forward_chain([transitive_rule], poker_data)

# Here's some other data sets for the rule. The tester uses
# these, so don't change them.
TEST_RESULTS_TRANS1 = forward_chain([transitive_rule],
                                    [ 'a beats b', 'b beats c' ])
TEST_RESULTS_TRANS2 = forward_chain([transitive_rule],
  [ 'rock beats scissors', 
    'scissors beats paper', 
    'paper beats rock' ])

print forward_chain([transitive_rule], [ 'a beats b', 'b beats c' ])

print forward_chain([transitive_rule],
  [ 'rock beats scissors', 
    'scissors beats paper', 
    'paper beats rock' ])
