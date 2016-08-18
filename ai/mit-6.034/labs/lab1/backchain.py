from production import AND, OR, NOT, PASS, FAIL, IF, THEN, \
     match, populate, simplify, variables
from zookeeper import ZOOKEEPER_RULES

# This function, which you need to write, takes in a hypothesis
# that can be determined using a set of rules, and outputs a goal
# tree of which statements it would need to test to prove that
# hypothesis. Refer to the problem set (section 2) for more
# detailed specifications and examples.

# Note that this function is supposed to be a general
# backchainer.  You should not hard-code anything that is
# specific to a particular rule set.  The backchainer will be
# tested on things other than ZOOKEEPER_RULES.


def backchain_to_goal_tree(rules, hypothesis):
    or_node = []

    for rule in rules:
        matches = False
        for c in rule.consequent():
            binding = match(c, hypothesis)
            if binding != None:
                matches = True
                sub_goals = []
                ant = rule.antecedent()
                if isinstance(ant, AND) or isinstance(ant, OR):
                    for a in ant:
                        pop = populate(a, binding)
                        sub_goals.append( AND ( backchain_to_goal_tree(rules, pop) ) )
                else:
                    pop = populate(ant, binding)
                    sub_goals.append( AND ( backchain_to_goal_tree(rules, pop) ) )
                if isinstance(ant, OR):
                    or_node.append( OR ( sub_goals ) )
                else:
                    or_node.append( AND ( sub_goals ) )
        if not matches:
            or_node.append( OR ( hypothesis ) )

    if len(or_node) == 0:
        or_node = OR (hypothesis)
    return simplify(OR ( or_node ))

# Here's an example of running the backward chainer - uncomment
# it to see it work:
rlz = (
    IF( AND( 'a (?x)',
             'b (?x)' ),
        THEN( 'c d' '(?x) e' )),
    IF( OR( '(?y) f e',
            '(?y) g' ),
        THEN( 'h (?y) j' )),
    IF( AND( 'h c d j',
             'h i j' ),
        THEN( 'zot' )),
    IF( '(?z) i',
        THEN( 'i (?z)' ))
    )
hyp = 'zot'
print backchain_to_goal_tree(rlz, hyp)
