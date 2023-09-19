--Program: Assignment 6
--Description: Haskell function for replicate
--Inputs:
  --replicate': Int and a element
  --perfects: Int
  --factors: Int
  --find: a element and a list of points
  --positions: Int and a list
  --scalarproduct: two lists of Ints
--Outputs:
  --1)
    --replicate 3 True -> [True,True,True]
    --repilicate 5 "test code" -> ["test code","test code","test code","test code","test code"]
  --2)
    --perfects 500 -> [6,28,496]
    --perfects 9000 -> [6,28,496, 8128]
  --3)
    --find 'b' [('a',1),('b',2),('c',3),('b',4)] -> [2,4]
    --find 'c' [('a',1),('b',2),('c',3),('b',4),('c',25)] -> [3,25]
  --4)
    --positions 0 [1,0,0,1,0,1,1,0] -> [1,2,4,7]
    --positions 1 [1,0,0,1,0,1,1,0] -> [0,3,5,6]
  --5)
    --scalarproduct [1,2,3][4,5,6] -> 32
    --scalarproduct [-1,2,3][-4,-5,6] -> 12
--Name: Ben Renner
--Creation Date: 11/14/2022
replicate' :: Int -> a -> [a] --takes in an int and a elements and returns a list of that elements of length Int
replicate' 0 _ = []
replicate' 1 x = [x]
replicate' n x
  | n > 0 = x : replicate' (n - 1) x
  | otherwise = []

--replicate 3 True -> [True,True,True]
--repilicate 5 "test code" -> ["test code","test code","test code","test code","test code"]
--2)perfects
perfects :: Int -> [Int] --takes in a int and returns a list of ints
perfects n = [x | x <- [2 .. n], sum (init (factors x)) == x] --returns a list of perfect ints

factors :: Int -> [Int] --takes in a int and returns a list of ints
factors n = [x | x <- [1 .. n], n `mod` x == 0] --returns a list of all the factors of the inputted int
--perfects 500 -> [6,28,496]
--perfects 9000 -> [6,28,496, 8128]
--3)find 
find :: Eq a => a-> [(a,b)] -> [b] --takes in a key and a list of points, and returns a list of values associated with the key
find n xs = [v | (n',v) <- xs, n == n'] --returns v if n == n'
--find 'b' [('a',1),('b',2),('c',3),('b',4)] -> [2,4]
--find 'c' [('a',1),('b',2),('c',3),('b',4),('c',25)] -> [3,25]
--4)positions
positions :: Eq a => a -> [a] -> [Int] --takes in a key and returns a list of the indexing of the keys
positions n xs = [v | (n',v) <- zip xs [0..], n == n']--returns a list of the indexes at which the the key n is equal to n'
--positions 0 [1,0,0,1,0,1,1,0] -> [1,2,4,7]
--positions 1 [1,0,0,1,0,1,1,0] -> [0,3,5,6]
--5)scalarproduct
scalarproduct :: [Int] -> [Int] -> Int --takes in 2 lists of ints are returns an int
scalarproduct xs ys = sum[a * b | (a,b) <- zip xs ys] --returns the sum of products for each index pair between the lists
--scalarproduct [1,2,3][4,5,6] -> 32
--scalarproduct [-1,2,3][-4,-5,6] -> 12
main = do
  print (replicate' 3 True)
  print (replicate' 5 "test code")
  print (perfects 500)
  print (perfects 9000)
  print (find 'b' [('a',1),('b',2),('c',3),('b',4)])
  print (find 'c' [('a',1),('b',2),('c',3),('b',4),('c',25)])
  print (positions 0 [1,0,0,1,0,1,1,0])
  print (positions 1 [1,0,0,1,0,1,1,0])
  print(scalarproduct [1,2,3] [4,5,6])
  print(scalarproduct [-1,2,3][-4,-5,6])
