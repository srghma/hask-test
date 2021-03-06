module Main where

import           Control.Monad.Writer
import           Protolude

-- writer1 - log
-- writer2 - times

program1 :: WriterT Text Identity ()
program1 = WriterT (Identity ((), ""))

program12 :: WriterT Integer Identity ()
program12 = WriterT (Identity ((), 1))
-- program12 = return () -- we could make like this if Integer had instance of monoid

type Computation = WriterT Text (WriterT [Integer] (Writer [Double]))

program2 :: Computation ()
program2 =
  let content = ((((), "9999"), [9999]), [9999.0])
  in  WriterT . WriterT . WriterT . Identity $ content

program4 :: WriterT Integer (WriterT Text Identity) ()
program4 = WriterT (writer (((), 1), ""))

program :: Computation ()
program = replicateM_ 3 $ do
  lift . lift $ tell [1.0]
  lift $ tell [1]
  tell "test"
  return ()

interpret :: Computation a -> ([Integer], [Double], Text)
interpret c =
  let (((_, text), integers), doubles) = runWriter (runWriterT (runWriterT c))
  in  (integers, doubles, text)

main :: IO ()
main = print (interpret program)
