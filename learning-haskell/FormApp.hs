import ApplicativeParsec

a_hex = hexify <$> (char '%' *> hexDigit) <*> hexDigit
  where hexify a b = toEnum . fst . head . readHex $ [a,b]

urlBaseChars = ['a'..'z']++['A'..'Z']++['0'..'9']++"$-_.!*'(),"

a_char = oneOf urlBaseChars
    <|> (' ' <$ char '+')
    <|> a_hex

a_pair = liftA2 (,) (many1 a_char) (optionMaybe (char '=' *> many a_char))
