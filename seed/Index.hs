module Index where

import Text.Html

page =
  thehtml ! [theclass "with-topbar"] << [
    header << [
      thelink ! [href "static/scaffold.css", rel "stylesheet",
                   thetype "text/css"] << noHtml,
      thetitle << "Barley"
      ],
    body << [
        h1 << "Welcome aboard!",
        p << "Barley is an environment and tutorial for exploring Haskell. \
             \Our aim is to make your first encounter with Haskell fun, \
             \enjoyable, and practical. " ,
        steps,
        topbar
        ]
    ]


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
  p << "That page is generated by a small program in the file named \
    \Template.hs in your project directory. Go open that in your \
    \favorite text editor. Try modifying it and saving it, then \
    \reload the template page to see the result." +++
  p << "Congratulations! You're writing Haskell!"
  )

topbar :: Html
topbar =thediv ! [identifier "topbar"] << [
    p << makelink haskellLink,
    unordList $ map makelink communityLinks
    ]
  where
    makelink (title, url) = anchor ! [href url] << title
    haskellLink = ("Haskell", "http://haskell.org/")
    communityLinks =
        [ ("Platform", "http://hackage.haskell.org/platform/")
        , ("Hackage", "http://hackage.haskell.org/packages/hackage.html")
        , ("λ Reddit", "http://www.reddit.com/r/haskell/")
        , ("λ Stack Overflow",
            "http://stackoverflow.com/questions/tagged?tagnames=haskell")
        ]

    