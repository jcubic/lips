(set-special! "::"
              (lambda ()
                (throw (new Error "ZONK")))
              lips.specials.SYMBOL)

::

