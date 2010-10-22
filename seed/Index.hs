module Index where

import DevUtils
import Text.Html

nu = () -- DO NOT DELETE THIS

page = devpage "Barley"
        [ h1 << "Welcome aboard!"
        , p << "Barley is an environment and tutorial for exploring Haskell. \
             \Our aim is to make your first encounter with Haskell fun, \
             \enjoyable, and practical. "
        , steps
        ]
        [ modMessage, modSteps, modTagLine ]
        []


type Step = (String, Html)

steps :: Html
steps = ordList $ map mkStep [step1, step2]
  where
    mkStep (title, text) = p << bold << title +++ thediv << text
    
step1 :: Step
step1 = ("Install and run Barley",
  p << "If you got here, you've done this step!"
  )

step2 :: Step
step2 = ("Try out your first page",
  p << ("There is a page called " +++
         anchor ! [ href "template" ] << "template" +++
         ". You should go look at it, and then come back here.") +++
  p << ("That page is generated by a small program in the file named " +++
    anchor ! [ href "source?file=Template.hs" ] << "Template.hs" +++
    " in your project directory. Click on that link or go open that in your \
    \favorite text editor. Try modifying it and saving it, then \
    \reload the template page to see the result.") +++
  p << "Congratulations! You're writing Haskell!"
  )


modMessage :: Html
modMessage = (h2 << "pre-Alpha version") +++
    (p << ("Just in case it wasn't totally clear: This is very early, \
          \pre-Alpha software. We're making it up as fast as we can! \
          \In the spirit of open source, we are developing in public, \
          \so please be gentle!" +++ br +++ "— Johan & Mark"))

modSteps :: Html
modSteps = (h2 << "Tutorial Steps") +++
    ordList [ "Step", "Step", "Quick-Step", "Slide" ] +++
    p << "This will be a list of the steps some day…"

modTagLine :: Html
modTagLine = pre << (
    "webSite :: " +++ (bold << "Haskell") +++ "\n\
    \webSite = madeWith\n\
    \  [ haskellPlatform\n\
    \  , snapFramework\n\
    \  , plugins\n\
    \  , ghc\n\
    \  ]"
    )


