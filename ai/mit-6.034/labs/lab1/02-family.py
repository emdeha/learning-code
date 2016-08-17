from production import IF, AND, OR, NOT, THEN, forward_chain

# Problem 1.3.2: Family relations

# First, define all your rules here individually. That is, give
# them names by assigning them to variables. This way, you'll be
# able to refer to the rules by name and easily rearrange them if
# you need to.

# x is the same as x
same = IF (
          OR ('male (?x)', 'female (?x)'),
       THEN ('same (?x) (?x)') )
# x is the sibling of y; y is the sibling of x
sibling = IF (
             OR ('brother (?x) (?y)', 'sister (?x) (?y)'),
          THEN ('sibling (?x) (?y)') )
# x is the brother of y
brother = IF (
             AND ('parent (?x) (?y)', 'parent (?x) (?z)',
                  'male (?y)', NOT ( 'same (?y) (?z)' )),
          THEN ('brother (?y) (?z)') )
# x is the sister of y
sister = IF (
             AND ('parent (?x) (?y)', 'parent (?x) (?z)',
                  'female (?y)', NOT ( 'same (?y) (?z)' )),
          THEN ('sister (?y) (?z)') )
# x is the mother of y
mother = IF (
            AND ('female (?x)', 'parent (?x) (?y)'),
         THEN ('mother (?x) (?y)') )
# x is the father of y
father = IF (
            AND ('male (?x)', 'parent (?x) (?y)'),
         THEN ('father (?x) (?y)') )
# x is the son of y
son = IF (
         AND ('male (?x)', 'parent (?y) (?x)'),
      THEN ('son (?x) (?y)') )
# x is the daughter of y
daughter = IF (
              AND ('female (?x)', 'parent (?y) (?x)'),
           THEN ('daughter (?x) (?y)') )
# x is the cousin of y
cousin = IF (
            AND ('parent (?a) (?x)', 'parent (?b) (?y)', 'sibling (?a) (?b)'),
         THEN ('cousin (?x) (?y)') )
# x is the grandparent of y
grandparent = IF (
                 AND ('parent (?x) (?y)', 'parent (?y) (?z)'),
              THEN ('grandparent (?x) (?z)') )
# x is the grandchild of y
grandchild = IF (
                AND ('parent (?x) (?y)', 'parent (?y) (?z)'),
             THEN ('grandchild (?z) (?x)') )


# Then, put them together into a list in order, and call it
# family_rules.
family_rules = [
  same,
  mother,
  father,
  son,
  daughter,
  grandparent,
  grandchild,
  brother,
  sister,
  sibling,
  cousin
]                    # fill me in

# Some examples to try it on:
# Note: These are used for testing, so DO NOT CHANGE
simpsons_data = ("male bart",
                 "female lisa",
                 "female maggie",
                 "female marge",
                 "male homer",
                 "male abe",
                 "parent marge bart",
                 "parent marge lisa",
                 "parent marge maggie",
                 "parent homer bart",
                 "parent homer lisa",
                 "parent homer maggie",
                 "parent abe homer")

TEST_RESULTS_6 = forward_chain(family_rules, simpsons_data, verbose=False)
# You can test your results by uncommenting this line:
# print forward_chain(family_rules, simpsons_data, verbose=True)

black_data = ("male sirius",
              "male regulus",
              "female walburga",
              "male alphard",
              "male cygnus",
              "male pollux",
              "female bellatrix",
              "female andromeda",
              "female narcissa",
              "female nymphadora",
              "male draco",
              "parent walburga sirius",
              "parent walburga regulus",
              "parent pollux walburga",
              "parent pollux alphard",
              "parent pollux cygnus",
              "parent cygnus bellatrix",
              "parent cygnus andromeda",
              "parent cygnus narcissa",
              "parent andromeda nymphadora",
              "parent narcissa draco")

# This should generate 14 cousin relationships, representing
# 7 pairs of people who are cousins:

black_family_cousins = [ 
    x for x in 
    forward_chain(family_rules, black_data, verbose=False) 
    if "cousin" in x ]

# To see if you found them all, uncomment this line:
# print black_family_cousins

# To debug what happened in your rules, you can set verbose=True
# in the function call above.

# Some other data sets to try it on. The tester uses these
# results, so don't comment them out.

TEST_DATA_1 = [ 'female alice',
                'male bob',
                'male chuck',
                'parent chuck alice',
                'parent chuck bob' ]
TEST_RESULTS_1 = forward_chain(family_rules, 
                               TEST_DATA_1, verbose=False)

TEST_DATA_2 = [ 'female a1', 'female b1', 'female b2', 
                'female c1', 'female c2', 'female c3', 
                'female c4', 'female d1', 'female d2', 
                'female d3', 'female d4',
                'parent a1 b1',
                'parent a1 b2',
                'parent b1 c1',
                'parent b1 c2',
                'parent b2 c3',
                'parent b2 c4',
                'parent c1 d1',
                'parent c2 d2',
                'parent c3 d3',
                'parent c4 d4' ]

TEST_RESULTS_2 = forward_chain(family_rules, 
                               TEST_DATA_2, verbose=False)

TEST_RESULTS_6 = forward_chain(family_rules,
                               simpsons_data,verbose=False)
