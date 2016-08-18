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
    goals = [OR ( hypothesis )]

    for rule in rules:
        for c in rule.consequent():
            binding = match(c, hypothesis)
            if binding != None:
                sub_goals = []
                ant = rule.antecedent()

                # Wrap leaf nodes
                if isinstance(ant, str):
                    ant = AND ( ant )

                for a in ant:
                    pop = populate(a, binding)
                    sub_goals.append( AND ( backchain_to_goal_tree(rules, pop) ) )

                # Take into account whether the antecedent is an AND
                # or OR node
                goals.append( type(ant) ( sub_goals ) )

    return simplify(OR ( goals ))

# Here's an example of running the backward chainer - uncomment
# it to see it work:
print backchain_to_goal_tree(ZOOKEEPER_RULES, 'opus is a penguin')
