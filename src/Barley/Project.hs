module Barley.Project
    ( ProjectDir(..)
    , enter
    , init
    ) where

import Control.Monad (unless, when)
import Paths_barley -- generated by cabal
import Prelude hiding (init)
import System.Directory
import System.Exit
import System.FilePath

-- | A specification of a project directory
data ProjectDir = CurrentDir | ProjectDir FilePath

projectPath :: ProjectDir -> FilePath
projectPath CurrentDir = "."  -- FIXME: The use of "." is probably not right
projectPath (ProjectDir fp) = fp
    
-- | The presence of this file indicates a directory is a barley project.
-- In the future we might store information in it.
markerFile :: FilePath
markerFile = ".barley-project"

-- | Change into the project directory.
-- Fails if the directory can't be entered.
enter :: ProjectDir -> IO ()
enter projectDir = do
    exists <- case projectDir of
        CurrentDir -> return True
        ProjectDir fp -> doesDirectoryExist fp
    unless exists $
        putStrLn ("Project directory doesn't exist: " ++ pdPath) >>
        exitFailure
    hasMarker <- doesFileExist (pdPath </> markerFile)
    unless hasMarker $
        putStrLn "Directory doesn't appear to be a Barely project." >>
        putStrLn ("Missing .barley-project file in directory: " ++ pdPath) >>
        exitFailure
    case projectDir of
        CurrentDir -> return ()
        ProjectDir fp -> setCurrentDirectory fp
  where
    pdPath = projectPath projectDir

-- | Create a project directory structure.
init :: Bool -> ProjectDir -> IO ()
init warnIfNotEmpty projectDir = nothingHere >>= \b -> if b
    then copyInitialProject projectDir
    else when warnIfNotEmpty $
        putStrLn "** This directory is not empty. Not initializing."
  where
    nothingHere = whatsHere >>= return . null . filter notDot
    whatsHere = case projectDir of
        CurrentDir -> getCurrentDirectory >>= getDirectoryContents 
        ProjectDir fp -> do
            exists <- doesDirectoryExist fp
            if exists
                then getDirectoryContents fp
                else return []
    notDot ('.':_) = False
    notDot _ = True

-- | Copy the initial project skeleton to the project directory.
copyInitialProject :: ProjectDir -> IO ()
copyInitialProject projectDir = do
    fromDir <- getSeedDir
    let toDir = projectPath projectDir
    putStrLn "Creating default project files..."
    copyTree fromDir toDir
    writeFile (toDir </> markerFile) ""
    putStrLn "...done."

-- | Locate seed dir in current dir, or data dir, or if neither, fail.
getSeedDir :: IO FilePath
getSeedDir = findFirstSeed [ getCurrentDirectory, getDataDir ]
  where
    findFirstSeed (g:gs) = do
        s <- g >>= return . (</> "seed")
        exists <- doesDirectoryExist s
        if exists
            then return s
            else findFirstSeed gs
    findFirstSeed [] = do
        putStrLn "** No seed directory found."
        putStrLn "** You should try reinstalling Barley."
        exitFailure

-- | Copy a directory tree from one place to another. The destination, or
-- the subtrees needn't exist. If they do, existing files with the same names
-- as the source will be overwritten. Other files will be left alone.
copyTree :: FilePath -> FilePath -> IO ()
copyTree from to = pick
    [(doesFileExist,        doFile),
     (doesDirectoryExist,   doDir)]
  where
    pick ((test, act):rest) = do
        bool <- test from
        if bool
            then putStrLn ("   " ++ to) >> act
            else pick rest
    pick [] =
        putStrLn $ "** Skipping funny thing in skeleton tree: " ++ from

    doFile = copyFile from to 
    doDir = do
        createDirectoryIfMissing False to
        getDirectoryContents from >>= mapM_ dive . filter notSpecial
        
    dive item = copyTree (from </> item) (to </> item)
    notSpecial item = item /= "." && item /= ".."
